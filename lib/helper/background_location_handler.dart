import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:skolo_driver/api/enums/socket_events_enum.dart';
import 'package:skolo_driver/api/services/position_queue_service.dart';
import 'package:skolo_driver/config/app_constants.dart';
import 'package:skolo_driver/config/environment.dart';

/// Background service entry point - runs in separate isolate
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final handler = BackgroundLocationHandler(service);

  // Register listeners FIRST so no messages are lost.
  // The main isolate sends 'startTracking' as soon as isRunning() returns true,
  // which can happen before handler.initialize() completes.
  service.on('stopService').listen((event) {
    handler.dispose();
    service.stopSelf();
  });

  service.on('startTracking').listen((event) async {
    if (event != null && event['tripId'] != null) {
      await handler.startTracking(event['tripId'] as String);
    }
  });

  service.on('stopTracking').listen((event) {
    handler.stopTracking();
  });

  // Initialize AFTER listeners are set up
  await handler.initialize();
}

/// iOS background fetch handler
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}

/// Handles background location tracking with socket and API updates
class BackgroundLocationHandler {
  BackgroundLocationHandler(this._service);

  final ServiceInstance _service;
  final _queueService = PositionQueueService();

  // Must match StorageService options for data accessibility
  FlutterSecureStorage get _secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          resetOnError: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  IO.Socket? _socket;
  bool _isSocketConnected = false;
  StreamSubscription<Position>? _locationSubscription;
  Timer? _queueSyncTimer;

  bool _isTrackingActive = false;
  String? _currentTripId;
  Position? _lastApiPosition;
  DateTime? _lastSocketEmitTime;
  // Don't use Endpoints.baseUrl here - it requires appConfig which isn't available in background isolate
  String _baseUrl = '';

  void _debug(String message) {
    print('[BG] $message');
    _service.invoke('debug', {'message': message});
  }

  Future<void> initialize() async {
    final storedBaseUrl = await _secureStorage.read(key: 'base_url');
    if (storedBaseUrl != null && storedBaseUrl.isNotEmpty) {
      _baseUrl = storedBaseUrl;
    } else {
      _baseUrl = EnvironmentConfig.production.baseUrl;
    }

    await _initializeSocket();
    _startQueueSync();
  }

  Future<void> _initializeSocket() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      final userId = await _secureStorage.read(key: 'user_id');

      if (token == null || token.isEmpty) {
        return;
      }

      final socketUrl = _baseUrl.replaceAll('/api', '');

      _socket = IO.io(socketUrl, <String, dynamic>{
        'reconnection': true,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'reconnectionAttempts': 99999,
        'transports': ['websocket'],
        'forceNew': true,
        'autoConnect': true,
        'auth': {
          'token': token,
          'userId': userId ?? '',
          'role': 'driver',
        },
      });

      _socket!.onConnect((_) {
        _isSocketConnected = true;
        if (_isTrackingActive && _currentTripId != null) {
          _subscribeToTrip(_currentTripId!);
        }
        _syncPendingSocketPositions();
      });

      _socket!.onDisconnect((reason) {
        _isSocketConnected = false;
      });

      _socket!.on('connect_error', (error) {
        _isSocketConnected = false;
        print('[D-BG] Connection error: $error');
      });
    } catch (e) {
      print('[D-BG] Socket init error: $e');
    }
  }

  Future<void> startTracking(String tripId) async {
    if (_isTrackingActive) {
      _currentTripId = tripId;
      return;
    }

    _isTrackingActive = true;
    _currentTripId = tripId;
    _lastApiPosition = null;
    _lastSocketEmitTime = null;

    // Clear stale pending positions from previous sessions
    await _queueService.clearAll();

    // CRITICAL: Subscribe to trip room BEFORE emitting any position updates
    await _subscribeToTrip(tripId);

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: AppConstants.backgroundDistanceFilter,
      ),
    ).listen(
      _handlePositionUpdate,
      onError: (error) {},
    );

    _service.invoke('trackingStarted', {'tripId': tripId});
  }

  void stopTracking() {
    // Unsubscribe from trip room before stopping
    if (_currentTripId != null) {
      _unsubscribeFromTrip(_currentTripId!);
    }

    _isTrackingActive = false;
    _currentTripId = null;
    _lastApiPosition = null;
    _lastSocketEmitTime = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;

    _service.invoke('trackingStopped');
  }

  Future<void> _subscribeToTrip(String tripId) async {
    if (_socket == null || !_isSocketConnected) {
      for (int i = 0; i < 50; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_isSocketConnected) break;
      }
      if (!_isSocketConnected) {
        print('[D-BG] Subscribe timeout for trip: $tripId');
        return;
      }
    }

    try {
      _socket!.emitWithAck(
        DriverSocketEvent.subscribeTrp.value,
        tripId,
        ack: (dynamic result) {
          if (!(result is bool ? result : result == true)) {
            print('[D-BG] Subscribe failed for trip: $tripId');
          }
        },
      );
    } catch (e) {
      print('[D-BG] Subscribe error: $e');
    }
  }

  void _unsubscribeFromTrip(String tripId) {
    if (_socket == null || !_isSocketConnected) return;
    try {
      _socket!.emit(DriverSocketEvent.unsubscribeTrp.value, tripId);
    } catch (e) {
      print('[D-BG] Unsubscribe error: $e');
    }
  }

  Future<void> _handlePositionUpdate(Position position) async {
    if (!_isTrackingActive || _currentTripId == null) return;

    final now = DateTime.now();
    final timestamp = now.toIso8601String();

    _service.invoke('positionUpdate', {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'speed': position.speed,
      'heading': position.heading,
      'accuracy': position.accuracy,
      'timestamp': timestamp,
    });

    // Socket emit every 10 seconds
    final shouldEmitSocket = _lastSocketEmitTime == null ||
        now.difference(_lastSocketEmitTime!) >= AppConstants.socketEmitInterval;

    if (shouldEmitSocket) {
      _lastSocketEmitTime = now;
      await _emitSocketPosition(position, timestamp);
    }

    // API update on 100m movement
    if (_shouldSendApiUpdate(position)) {
      _lastApiPosition = position;
      await _sendApiPosition(position, timestamp);
    }
  }

  Future<void> _emitSocketPosition(Position position, String timestamp) async {
    final data = {
      'tripId': _currentTripId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'speed': position.speed,
      'heading': position.heading,
      'accuracy': position.accuracy,
      'timestamp': timestamp,
    };

    if (_isSocketConnected && _socket != null) {
      try {
        _socket!.emit(DriverSocketEvent.updatePosition.value, data);
      } catch (e) {
        await _queuePosition(position, timestamp, 'socket');
      }
    } else {
      await _queuePosition(position, timestamp, 'socket');
    }
  }

  Future<void> _sendApiPosition(Position position, String timestamp) async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        await _queuePosition(position, timestamp, 'api');
        return;
      }

      final url = '$_baseUrl/tracking/$_currentTripId/position';
      final response = await http
          .patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'latitude': position.latitude,
              'longitude': position.longitude,
              'speed': position.speed,
              'heading': position.heading,
              'accuracy': position.accuracy,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        await _queuePosition(position, timestamp, 'api');
      }
    } catch (e) {
      await _queuePosition(position, timestamp, 'api');
    }
  }

  Future<void> _queuePosition(
      Position position, String timestamp, String type) async {
    try {
      await _queueService.enqueue(
        tripId: _currentTripId!,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
        accuracy: position.accuracy,
        timestamp: timestamp,
        type: type,
      );
    } catch (_) {}
  }

  bool _shouldSendApiUpdate(Position currentPosition) {
    if (_lastApiPosition == null) return true;

    final distance = _calculateDistance(
      _lastApiPosition!.latitude,
      _lastApiPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return distance >= AppConstants.apiUpdateDistanceFilter;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  void _startQueueSync() {
    _queueSyncTimer?.cancel();
    _queueSyncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _syncPendingSocketPositions();
      _syncPendingApiPositions();
    });
  }

  Future<void> _syncPendingSocketPositions() async {
    if (!_isSocketConnected || _socket == null) return;

    try {
      final pending = await _queueService.getPending(type: 'socket', limit: 20);
      if (pending.isEmpty) return;

      final syncedIds = <int>[];
      for (final pos in pending) {
        try {
          // Only sync positions for the current active trip
          // Skip if this position belongs to a different trip
          if (pos['trip_id'] != _currentTripId) continue;

          _socket!.emit(DriverSocketEvent.updatePosition.value, {
            'tripId': pos['trip_id'],
            'latitude': pos['latitude'],
            'longitude': pos['longitude'],
            'speed': pos['speed'],
            'heading': pos['heading'],
            'accuracy': pos['accuracy'],
            'timestamp': pos['timestamp'],
          });
          syncedIds.add(pos['id'] as int);
        } catch (e) {
          break;
        }
      }

      if (syncedIds.isNotEmpty) {
        await _queueService.markSynced(syncedIds);
      }
    } catch (_) {}
  }

  Future<void> _syncPendingApiPositions() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) return;

      final pending = await _queueService.getPendingApiPositions(limit: 10);
      if (pending.isEmpty) return;

      // Only send the latest position for the current trip — server only needs
      // the most recent location. Mark all others as synced to prevent buildup.
      final allIds = <int>[];
      Map<String, dynamic>? latestPos;
      for (final pos in pending) {
        allIds.add(pos['id'] as int);
        if (pos['trip_id'] == _currentTripId) {
          latestPos = pos;
        }
      }

      if (latestPos != null) {
        try {
          final url = '$_baseUrl/tracking/${latestPos['trip_id']}/position';
          final response = await http
              .patch(
                Uri.parse(url),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({
                  'latitude': latestPos['latitude'],
                  'longitude': latestPos['longitude'],
                  'speed': latestPos['speed'],
                  'heading': latestPos['heading'],
                  'accuracy': latestPos['accuracy'],
                }),
              )
              .timeout(const Duration(seconds: 10));

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Mark all pending as synced (not just the one sent)
            await _queueService.markSynced(allIds);
          } else {
            // Mark as synced anyway to prevent infinite retry loop
            await _queueService.markSynced(allIds);
          }
        } catch (_) {
          // Mark as synced on failure to prevent stale positions retrying forever
          await _queueService.markSynced(allIds);
        }
      } else {
        // No positions for current trip — mark all as synced to clear stale data
        await _queueService.markSynced(allIds);
      }
    } catch (_) {}
  }

  void dispose() {
    _queueSyncTimer?.cancel();
    _queueSyncTimer = null;
    _locationSubscription?.cancel();
    _socket?.disconnect();
    _socket?.dispose();
  }
}
