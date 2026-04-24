import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skolo_driver/api/services/pick_up_customer_service.dart';
import 'package:skolo_driver/api/services/socket_service.dart';
import 'package:skolo_driver/api/enums/trip_status_enum.dart';
import 'package:skolo_driver/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:skolo_driver/api/models/pick_up_customer/pickup_point_response.dart';
import 'package:skolo_driver/api/models/pick_up_customer/school_point_response.dart';
import 'package:skolo_driver/api/models/pick_up_customer/trip_progress_response.dart';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/helper/foreground_tracking_service.dart';

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
  StreamSubscription<Map<String, dynamic>>? _routeUpdateSubscription;

  final _notificationController = StreamController<String>.broadcast();
  Stream<String> get notificationStream => _notificationController.stream;

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

  DateTime? _lastRouteUpdate;

  /// Listen for server-recalculated routes via socket and update optimizedRoute
  void _setupRouteUpdateListener() {
    _routeUpdateSubscription?.cancel();
    _routeUpdateSubscription =
        _socketService.routeUpdatesStream.listen((data) {
      // Deduplicate — server may broadcast multiple times per recalc
      final now = DateTime.now();
      if (_lastRouteUpdate != null &&
          now.difference(_lastRouteUpdate!).inSeconds < 3) {
        return;
      }
      _lastRouteUpdate = now;

      print('[D] Route update received: $data');
      try {
        // Socket sends { tripId, routeData: { waypoints, coordinates, legs, ... } }
        final routeData = data['routeData'];
        if (routeData != null) {
          final geometry = RouteGeometry.fromJson(
              routeData is Map<String, dynamic>
                  ? routeData
                  : Map<String, dynamic>.from(routeData as Map));
          optimizedRoute = OptimizedRoute(
            id: optimizedRoute?.id ?? '',
            tripId: data['tripId']?.toString() ?? optimizedRoute?.tripId ?? '',
            routeGeometry: geometry,
          );
          _notificationController.add('Route recalculated');
          notifyListeners();
          return;
        }
      } catch (e) {
        print('[D] Route update parse error: $e');
      }
    });
  }

  /// Get school_id of current waypoint (for multi-school route filtering)
  /// Returns null if no route or waypoint index is out of bounds
  String? getCurrentWaypointSchoolId(int currentWaypointIndex) {
    if (optimizedRoute == null) return null;
    final waypoints = optimizedRoute!.routeGeometry.waypoints;
    if (currentWaypointIndex >= waypoints.length) return null;
    return waypoints[currentWaypointIndex].schoolIds?.isNotEmpty == true
        ? waypoints[currentWaypointIndex].schoolIds!.first
        : null;
  }

  /// Get current waypoint object
  RouteWaypoint? getCurrentWaypoint(int currentWaypointIndex) {
    if (optimizedRoute == null) return null;
    final waypoints = optimizedRoute!.routeGeometry.waypoints;
    if (currentWaypointIndex >= waypoints.length) return null;
    return waypoints[currentWaypointIndex];
  }

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
  /// Pass the trip _id for both REST API and socket operations
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

        final socketTripId = optimizedRoute?.tripId ?? tripId;

        // Emit trip started via socket from main isolate
        // NOTE: Room subscription happens in BackgroundLocationHandler when tracking starts
        if (tripStatus == TripStatus.started.value) {
          await _socketService.initializeSocket(forceRefresh: true);
          _setupRouteUpdateListener();
          await _socketService.subscribeToTrip(socketTripId);
          _socketService.startTripViaWebSocket(socketTripId);
        }

        if (tripStatus == TripStatus.inProgress.value) {
          await _socketService.initializeSocket(forceRefresh: true);
          _setupRouteUpdateListener();
          await _socketService.subscribeToTrip(socketTripId);
        }

        // Emit trip completed and unsubscribe from trip room
        if (tripStatus == TripStatus.completed.value) {
          _socketService.completeTripViaWebSocket(socketTripId);
          // Unsubscription happens in BackgroundLocationHandler when tracking stops
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
  /// [skippedStudentIds] is optional - used for both PICKUP and DROP trips when students are absent/skipped
  Future<SchoolPointResponse?> processSchoolPoint({
    required String tripId,
    required List<String> studentIds,
    required double latitude,
    required double longitude,
    String? schoolId,
    List<String>? skippedStudentIds,
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
        schoolId: schoolId,
        skippedStudentIds: skippedStudentIds,
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

  /// Get trip progress information
  /// Returns TripProgressData on success, null on failure
  Future<TripProgressData?> getTripProgress({
    required String tripId,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.getTripProgress(
        tripId: tripId,
      );

      if (response.success && response.data != null) {
        successMessage =
            response.message ?? 'Trip progress retrieved successfully';
        isLoading = false;
        notifyListeners();
        return response.data;
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Failed to get trip progress';
        isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      errorMessage = 'Error getting trip progress: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _statusSubscription?.cancel();
    _routeUpdateSubscription?.cancel();
    _notificationController.close();
    stopLocationTracking();
    super.dispose();
  }
}
