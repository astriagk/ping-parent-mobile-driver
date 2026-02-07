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
    // If already initialized and not forcing refresh, skip
    if (_isInitialized && !forceRefresh) {
      // But check if socket is actually connected
      if (_socket != null && _socket!.connected) {
        print('[Socket] ✅ Already connected, reusing existing connection');
        return;
      }
    }

    // Disconnect existing socket if forcing refresh
    if (forceRefresh && _socket != null) {
      try {
        _socket!.disconnect();
        _socket!.dispose();
      } catch (e) {
        print('[Socket] Error disposing old socket: $e');
      }
      _isInitialized = false;
      _isConnected = false;
    }

    try {
      final baseUrl = Endpoints.baseUrl.replaceAll('/api', '');
      final token = await _storageService.getAuthToken();
      final userId = await _storageService.getUserId();

      if (token == null || token.isEmpty) {
        print('[Socket] ❌ No auth token found in storage');
        return;
      }

      print('[Socket] Initializing connection to: $baseUrl');
      print('[Socket] 🔑 Using token from storage (length: ${token.length})');

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
        print('[Socket] ✅ CONNECTED');
        onConnected?.call();
      });

      // Connection disconnected
      _socket!.onDisconnect((_) {
        _isConnected = false;
        print('[Socket] ❌ DISCONNECTED');
        onDisconnected?.call();
      });

      // Connection error
      _socket!.on('connect_error', (error) {
        _isConnected = false;
        print('[Socket] ⚠️ CONNECTION ERROR: $error');
      });

      // General error
      _socket!.on('error', (error) {
        print('[Socket] ⚠️ ERROR: $error');
        if (error is Map && error.containsKey('message')) {
          if (error['message'] == 'Invalid authentication') {
            print('[Socket] 🔍 Auth failed - Token may be expired or invalid');
          }
        }
      });

      _isInitialized = true;
      print('[Socket] ⏳ Waiting for connection...');
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
      print('[Socket] ⚠️ Connection timeout after 10s - will auto-reconnect');
    }
  }

  /// Get socket connected status
  bool get isConnected => _isConnected && _socket != null && _socket!.connected;

  /// Emit trip started event
  void startTripViaWebSocket(String tripId) {
    if (!isConnected || _socket == null) {
      print('[Socket] ❌ Cannot emit trip_started - socket not connected');
      return;
    }

    try {
      print(
          '[Socket] 📤 Emitting: ${DriverSocketEvent.tripStarted.value} for trip: $tripId');
      _socket!.emit(DriverSocketEvent.tripStarted.value, {'tripId': tripId});
      print('[Socket] ✅ Trip started event emitted');
    } catch (e) {
      print('[Socket] ❌ Error emitting trip_started: $e');
    }
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
    final timestamp = DateTime.now().toIso8601String();

    if (!isConnected || _socket == null) {
      return;
    }

    try {
      final data = {
        'tripId': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'heading': heading,
        'accuracy': accuracy,
        'timestamp': timestamp,
      };

      _socket!.emit(DriverSocketEvent.updatePosition.value, data);
    } catch (e) {
      print('[Socket] Error emitting position: $e');
    }
  }

  /// Disconnect socket
  void disconnect() {
    try {
      _socket?.disconnect();
      _isConnected = false;
      _isInitialized = false;
      print('[Socket] ⏹️ Socket disconnected manually');
    } catch (e) {
      print('[Socket] Error disconnecting: $e');
    }
  }

  /// Reconnect socket with fresh token from storage
  Future<void> reconnect() async {
    try {
      print('[Socket] 🔄 Reconnecting with fresh token...');
      await initializeSocket(forceRefresh: true);
    } catch (e) {
      print('[Socket] Error reconnecting: $e');
    }
  }
}
