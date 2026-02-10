import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxify_driver_ui/api/services/pick_up_customer_service.dart';
import 'package:taxify_driver_ui/api/services/socket_service.dart';
import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/pickup_point_response.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/school_point_response.dart';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/helper/foreground_tracking_service.dart';

/// Provider for managing trip pickup and location tracking
/// Uses ForegroundTrackingService for reliable background location tracking
class PickUpCustomerProvider extends ChangeNotifier {
  late final PickUpCustomerService _pickUpCustomerService;
  late final SocketService _socketService;
  late final ForegroundTrackingService _trackingService;

  bool isLoading = false;
  String? successMessage;
  String? errorMessage;
  OptimizedRoute? optimizedRoute;

  // Tracking state
  bool _isTrackingActive = false;
  StreamSubscription<Map<String, dynamic>>? _positionSubscription;
  StreamSubscription<String>? _statusSubscription;

  // Current position for UI
  double? currentLatitude;
  double? currentLongitude;

  PickUpCustomerProvider() {
    _pickUpCustomerService = PickUpCustomerService(ApiClient());
    _socketService = SocketService();
    _trackingService = ForegroundTrackingService();
    _setupTrackingListeners();
  }

  /// Setup listeners for tracking service updates
  void _setupTrackingListeners() {
    // Listen for position updates from background service
    _positionSubscription = _trackingService.positionStream.listen((position) {
      currentLatitude = position['latitude'] as double?;
      currentLongitude = position['longitude'] as double?;
      notifyListeners();
    });

    // Listen for tracking status changes
    _statusSubscription = _trackingService.statusStream.listen((status) {
      if (status == 'started') {
        _isTrackingActive = true;
      } else if (status == 'stopped') {
        _isTrackingActive = false;
      }
      notifyListeners();
    });
  }

  /// Get tracking active state
  bool get isTrackingActive => _isTrackingActive;

  /// Fetch optimized route from TomTom tracking API
  Future<bool> fetchOptimizedRoute({
    required String tripId,
    required double currentLatitude,
    required double currentLongitude,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.fetchOptimizedRoute(
        tripId: tripId,
        currentLatitude: currentLatitude,
        currentLongitude: currentLongitude,
      );

      if (response.success && response.data != null) {
        optimizedRoute = response.data;
        successMessage = response.message;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message ?? 'Failed to fetch route';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error fetching optimized route: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update trip status (e.g., "started", "completed")
  /// Pass the trip ID from the optimized route response (_id field) for REST API
  /// Socket operations use business tripId (e.g., "TRP-123456") from optimizedRoute
  /// Per WEBSOCKET.md v3.1.0: Must subscribe before emitting trip_started
  Future<bool> updateTripStatus({
    required String tripId,
    required String tripStatus,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      // REST API uses MongoDB _id (tripId parameter)
      final response = await _pickUpCustomerService.updateTripStatus(
        tripId: tripId,
        tripStatus: tripStatus,
      );

      if (response.success && response.data != null) {
        successMessage = response.message ?? 'Trip status updated successfully';

        // Socket operations use business tripId (e.g., "TRP-123456")
        final socketTripId = optimizedRoute?.tripId ?? tripId;

        // Emit trip started via socket from main isolate
        if (tripStatus == TripStatus.started.value) {
          await _socketService.initializeSocket(forceRefresh: true);

          // IMPORTANT: Subscribe to trip before emitting events per v3.1.0
          final subscribed = await _socketService.subscribeToTrip(socketTripId);
          if (!subscribed) {
            print(
                '[Provider] ⚠️ Failed to subscribe to trip, continuing anyway');
          }

          _socketService.startTripViaWebSocket(socketTripId);
        }

        // Emit trip completed and unsubscribe from trip room
        if (tripStatus == TripStatus.completed.value) {
          _socketService.completeTripViaWebSocket(socketTripId);
          _socketService.unsubscribeFromTrip(socketTripId);
        }

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message ?? 'Failed to update trip status';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error updating trip status: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start location tracking using ForegroundTrackingService
  /// This starts a native foreground service that:
  /// 1. Emits position via socket every 10 seconds
  /// 2. Sends API call every 100 meters
  /// Works reliably in BOTH foreground and background
  Future<void> startLocationTracking(String tripId) async {
    if (_isTrackingActive) return;

    try {
      await _trackingService.startTracking(tripId);
      _isTrackingActive = true;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to start location tracking';
      notifyListeners();
    }
  }

  /// Stop location tracking
  Future<void> stopLocationTracking() async {
    if (!_isTrackingActive) return;

    _trackingService.stopTracking();
    _isTrackingActive = false;
    notifyListeners();
  }

  /// Stop the background service completely (call on logout or app close)
  Future<void> stopTrackingService() async {
    await _trackingService.stopService();
  }

  /// Get current position (single fetch, not stream)
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get location stream for UI map updates (separate from tracking)
  Stream<Position> getLocationStream({
    int distanceFilter = 15,
    Duration timeLimit = const Duration(seconds: 30),
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        timeLimit: timeLimit,
      ),
    );
  }

  /// Verify daily QR OTP and return student IDs if valid
  /// Returns list of student IDs on success, null on failure
  Future<List<String>?> verifyDailyQrOtp({
    required String parentId,
    required String tripId,
    required String otpCode,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.verifyDailyQrOtp(
        parentId: parentId,
        tripId: tripId,
        otpCode: otpCode,
      );

      if (response.success && response.data != null) {
        successMessage = response.message ?? 'OTP verified successfully';
        isLoading = false;
        notifyListeners();
        return response.data!.studentIds;
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Failed to verify OTP';
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Error verifying OTP: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Process pickup point for multiple students
  /// Handles present and absent students in a single API call
  /// Returns PickupPointResponse on success, null on failure
  Future<PickupPointResponse?> processPickupPoint({
    required String tripId,
    required List<String> studentIds,
    required List<String> absentStudentIds,
    String? otpCode,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.processPickupPoint(
        tripId: tripId,
        studentIds: studentIds,
        absentStudentIds: absentStudentIds,
        otpCode: otpCode,
        latitude: latitude,
        longitude: longitude,
      );

      if (response.success && response.data != null) {
        successMessage =
            response.message ?? 'Pickup point processed successfully';
        isLoading = false;
        notifyListeners();
        return response;
      } else {
        errorMessage = response.error ??
            response.message ??
            'Failed to process pickup point';
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Error processing pickup point: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Process school point for dropping students at school
  /// Returns SchoolPointResponse on success, null on failure
  Future<SchoolPointResponse?> processSchoolPoint({
    required String tripId,
    required List<String> studentIds,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.processSchoolPoint(
        tripId: tripId,
        studentIds: studentIds,
        latitude: latitude,
        longitude: longitude,
      );

      if (response.success && response.data != null) {
        successMessage =
            response.message ?? 'School point processed successfully';
        isLoading = false;
        notifyListeners();
        return response;
      } else {
        errorMessage = response.error ??
            response.message ??
            'Failed to process school point';
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Error processing school point: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _statusSubscription?.cancel();
    stopLocationTracking();
    super.dispose();
  }
}
