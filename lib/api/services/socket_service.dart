import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/enums/socket_events_enum.dart';
import 'package:taxify_driver_ui/api/services/storage_service.dart';

/// Socket Service for real-time communication
/// Used in MAIN ISOLATE only for UI-related socket events
/// Background location tracking uses its own socket in BackgroundLocationHandler
class SocketService {
  static final SocketService _instance = SocketService._internal();
  IO.Socket? _socket;
  bool _isInitialized = false;
  bool _isConnected = false;
  final _storageService = StorageService();

  // Connection state callbacks
  Function()? onConnected;
  Function()? onDisconnected;

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  /// Initialize socket connection - Must be awaited
  /// Will fetch fresh token from storage each time
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
        print('[Socket] ❌ No auth token');
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

      // Connection established
      _socket!.onConnect((_) {
        _isConnected = true;
        print('[Socket] ✅ Connected');
        onConnected?.call();
      });

      // Connection disconnected
      _socket!.onDisconnect((_) {
        _isConnected = false;
        print('[Socket] ❌ Disconnected');
        onDisconnected?.call();
      });

      // Connection error
      _socket!.on('connect_error', (error) {
        _isConnected = false;
        print('[Socket] ❌ Error: $error');
      });

      // General error
      _socket!.on('error', (error) {
        print('[Socket] ❌ Error: $error');
      });

      // Socket/Authorization errors from server
      _socket!.on(BroadcastSocketEvent.error.value, (data) {
        if (data is Map && data.containsKey('message')) {
          print('[Socket] ❌ ${data['message']}');
        }
      });

      // Silent broadcast event listeners
      _socket!.on(BroadcastSocketEvent.positionUpdate.value, (_) {});
      _socket!.on(BroadcastSocketEvent.tripStarted.value, (_) {});
      _socket!.on(BroadcastSocketEvent.tripCompleted.value, (_) {});
      _socket!.on(BroadcastSocketEvent.routeCalculated.value, (_) {});
      _socket!.on(BroadcastSocketEvent.approaching.value, (_) {});
      _socket!.on(BroadcastSocketEvent.studentPicked.value, (_) {});
      _socket!.on(BroadcastSocketEvent.studentDropped.value, (_) {});

      _isInitialized = true;
      await _waitForConnection();
    } catch (e) {
      print('[Socket] ❌ Init failed: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Wait for socket to connect (max 10 seconds)
  Future<void> _waitForConnection() async {
    int attempts = 0;
    while (!_isConnected && attempts < 100) {
      await Future.delayed(Duration(milliseconds: 100));
      attempts++;
    }

    if (!_isConnected) {
      print('[Socket] ⚠️ Connection timeout');
    }
  }

  /// Get socket connected status
  bool get isConnected => _isConnected && _socket != null && _socket!.connected;

  /// Subscribe to trip - Must be called after initialization
  /// Required before sending position updates per WEBSOCKET.md v3.1.0
  Future<bool> subscribeToTrip(String tripId) async {
    if (!isConnected || _socket == null) return false;

    try {
      _socket!.emitWithAck(
        DriverSocketEvent.subscribeTrp.value,
        tripId,
        ack: (dynamic result) {
          if (!(result is bool ? result : result == true)) {
            print('[Socket] ❌ Subscribe failed: $tripId');
          }
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Unsubscribe from trip - Cleanup when trip ends
  void unsubscribeFromTrip(String tripId) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.unsubscribeTrp.value, tripId);
    } catch (_) {}
  }

  /// Emit trip started event
  void startTripViaWebSocket(String tripId) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.tripStarted.value, tripId);
      print('[Socket] 📤 Trip started: $tripId');
    } catch (_) {}
  }

  /// Emit trip completed event
  void completeTripViaWebSocket(String tripId) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.tripCompleted.value, tripId);
      print('[Socket] 📤 Trip COMPLETED: $tripId → notifying all parents');
    } catch (_) {}
  }

  /// Emit approaching waypoint event when near student location
  void approachingWaypointViaWebSocket({
    required String tripId,
    required String studentId,
    required int etaSeconds,
  }) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.approachingWaypoint.value,
          {'tripId': tripId, 'studentId': studentId, 'eta': etaSeconds});
      print(
          '[Socket] 📤 Approaching student: $studentId (ETA: ${etaSeconds}s) → notifying parent');
    } catch (_) {}
  }

  /// Emit student picked up event
  void studentPickedViaWebSocket({
    required String tripId,
    required String studentId,
  }) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.studentPicked.value,
          {'tripId': tripId, 'studentId': studentId});
      print(
          '[Socket] 📤 Student PICKED: $studentId (trip: $tripId) → notifying parent');
    } catch (_) {}
  }

  /// Emit student dropped off event
  void studentDroppedViaWebSocket({
    required String tripId,
    required String studentId,
  }) {
    if (!isConnected || _socket == null) return;
    try {
      _socket!.emit(DriverSocketEvent.studentDropped.value,
          {'tripId': tripId, 'studentId': studentId});
      print(
          '[Socket] 📤 Student DROPPED: $studentId (trip: $tripId) → notifying parent');
    } catch (_) {}
  }

  /// Update driver position - Main method for sending position every 10 seconds
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
      print('[Socket] 📍 Position: $latitude, $longitude');
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
