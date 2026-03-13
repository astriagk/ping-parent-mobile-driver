import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/enums/socket_events_enum.dart';
import 'package:skolo_driver/api/services/storage_service.dart';

/// Driver socket service - Main isolate only
class SocketService {
  static final SocketService _instance = SocketService._internal();
  IO.Socket? _socket;
  bool _isInitialized = false;
  bool _isConnected = false;
  String? _subscribedTripId;
  final _storageService = StorageService();

  Function()? onConnected;
  Function()? onDisconnected;

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  Future<void> initializeSocket({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) {
      if (_socket != null && _socket!.connected) return;
    }

    if (forceRefresh && _socket != null) {
      try {
        _socket!.disconnect();
        _socket!.dispose();
      } catch (_) {}
      _isInitialized = false;
      _isConnected = false;
    }

    try {
      final baseUrl = Endpoints.baseUrl.replaceAll('/api', '');
      final token = await _storageService.getAuthToken();
      final userId = await _storageService.getUserId();

      if (token == null || token.isEmpty) {
        print('[D] No auth token');
        return;
      }

      _socket = IO.io(baseUrl, <String, dynamic>{
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
        _isConnected = true;
        onConnected?.call();
      });

      _socket!.onDisconnect((reason) {
        _isConnected = false;
        onDisconnected?.call();
      });

      _socket!.onReconnect((attemptNumber) {
        _isConnected = true;
        if (_subscribedTripId != null) {
          subscribeToTrip(_subscribedTripId!);
        }
      });

      _socket!.on('connect_error', (error) {
        _isConnected = false;
        print('[D] Connection error: $error');
      });

      _socket!.on(BroadcastSocketEvent.error.value, (data) {
        if (data is Map && data.containsKey('message')) {
          print('[D] Error: ${data['message']}');
        }
      });

      _isInitialized = true;
      await _waitForConnection();
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> _waitForConnection() async {
    int attempts = 0;
    while (!_isConnected && attempts < 100) {
      await Future.delayed(Duration(milliseconds: 100));
      attempts++;
    }
  }

  /// Get socket connected status
  bool get isConnected => _isConnected && _socket != null && _socket!.connected;

  Future<bool> subscribeToTrip(String tripId) async {
    if (!isConnected || _socket == null) return false;

    try {
      _subscribedTripId = tripId;
      _socket!.emitWithAck(
        DriverSocketEvent.subscribeTrp.value,
        tripId,
        ack: (dynamic result) {
          if (!(result is bool ? result : result == true)) {
            print('[D] Subscribe failed for trip: $tripId');
          }
        },
      );
      return true;
    } catch (e) {
      print('[D] Subscribe error: $e');
      return false;
    }
  }

  void unsubscribeFromTrip(String tripId) {
    if (!isConnected || _socket == null) {
      _subscribedTripId = null;
      return;
    }
    try {
      _socket!.emit(DriverSocketEvent.unsubscribeTrp.value, tripId);
      _subscribedTripId = null;
    } catch (e) {
      print('[D] Unsubscribe error: $e');
    }
  }

  void startTripViaWebSocket(String tripId) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.tripStarted.value, tripId);
    } catch (e) {
      print('[D] Trip start error: $e');
    }
  }

  void completeTripViaWebSocket(String tripId) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.tripCompleted.value, tripId);
    } catch (e) {
      print('[D] Trip complete error: $e');
    }
  }

  void updateDriverPosition({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
  }) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.updatePosition.value, {
        'tripId': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'heading': heading,
        'accuracy': accuracy,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('[D] 📍 Position: $latitude, $longitude');
    } catch (_) {}
  }

  /// Disconnect socket
  void disconnect() {
    try {
      _socket?.disconnect();
      _isConnected = false;
      _isInitialized = false;
    } catch (_) {}
  }

  Future<void> reconnect() async {
    try {
      await initializeSocket(forceRefresh: true);
    } catch (_) {}
  }
}
