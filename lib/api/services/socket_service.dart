import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  bool _isInitialized = false;

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  void initializeSocket() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final baseUrl = Endpoints.baseUrl.replaceAll('/api', '');
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      socket = IO.io(baseUrl, <String, dynamic>{
        'reconnection': true,
        'reconnection delay': 1000,
        'reconnection delay max': 5000,
        'reconnection attempts': 99999,
        'transports': ['websocket'],
        'forceNew': false,
        'rejectUnauthorized': false,
        'auth': {
          'token': token ?? '',
        },
      });

      socket.onConnect((_) {});
      socket.onDisconnect((_) {});
      socket.on('connect_error', (error) {});
      socket.on('error', (error) {});
    } catch (e) {
      _isInitialized = false;
    }
  }

  void startTripViaWebSocket(String tripId) {
    try {
      socket.emit('driver:trip_started', {
        'tripId': tripId,
      });
    } catch (e) {}
  }

  void sendImmediatePositionUpdate({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
  }) {
    try {
      socket.emit('driver:update_position', {
        'tripId': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'heading': heading,
        'accuracy': accuracy,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {}
  }

  void updateDriverPosition({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
  }) {
    try {
      socket.emit('driver:update_position', {
        'tripId': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'heading': heading,
        'accuracy': accuracy,
      });
    } catch (e) {}
  }

  void disconnect() {
    socket.disconnect();
  }

  void reconnect() {
    socket.connect();
  }

  bool get isConnected => socket.connected;
}
