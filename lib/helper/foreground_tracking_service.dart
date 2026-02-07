import 'dart:async';
import 'dart:io';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/helper/background_location_handler.dart';

/// Manages background service lifecycle and UI communication
class ForegroundTrackingService {
  static final ForegroundTrackingService _instance =
      ForegroundTrackingService._internal();

  factory ForegroundTrackingService() => _instance;

  ForegroundTrackingService._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();
  bool _isInitialized = false;

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

  final _positionController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _statusController = StreamController<String>.broadcast();

  Stream<Map<String, dynamic>> get positionStream => _positionController.stream;
  Stream<String> get statusStream => _statusController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _secureStorage.write(key: 'base_url', value: Endpoints.baseUrl);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'trip_tracking_channel',
        'Trip Tracking',
        description: 'Shows notification when trip tracking is active',
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: false,
        notificationChannelId: 'trip_tracking_channel',
        initialNotificationTitle: 'Trip Active',
        initialNotificationContent: 'Location tracking in progress',
        foregroundServiceNotificationId: 888,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    _service.on('positionUpdate').listen((event) {
      if (event != null) {
        _positionController.add(Map<String, dynamic>.from(event));
      }
    });

    // Listen for debug messages from background isolate
    _service.on('debug').listen((event) {
      if (event != null && event['message'] != null) {
        print('[BG-DEBUG] ${event['message']}');
      }
    });

    _service.on('trackingStarted').listen((event) {
      _statusController.add('started');
    });

    _service.on('trackingStopped').listen((event) {
      _statusController.add('stopped');
    });

    _isInitialized = true;
  }

  Future<bool> isRunning() async {
    return await _service.isRunning();
  }

  Future<void> startService() async {
    if (!_isInitialized) {
      await initialize();
    }

    final isRunning = await _service.isRunning();
    if (!isRunning) {
      await _service.startService();
    }
  }

  Future<void> startTracking(String tripId) async {
    await startService();

    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (await _service.isRunning()) break;
    }

    _service.invoke('startTracking', {'tripId': tripId});
    _statusController.add('starting');
  }

  void stopTracking() {
    _service.invoke('stopTracking');
    _statusController.add('stopping');
  }

  Future<void> stopService() async {
    _service.invoke('stopService');
    _statusController.add('stopped');
  }

  void updateNotification({required String title, required String content}) {
    if (Platform.isAndroid) {
      _service.invoke('updateNotification', {
        'title': title,
        'content': content,
      });
    }
  }

  void dispose() {
    _positionController.close();
    _statusController.close();
  }
}
