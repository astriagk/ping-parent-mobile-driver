import 'package:flutter/material.dart';
import 'package:taxify_driver_ui/api/services/pick_up_customer_service.dart';
import 'package:taxify_driver_ui/api/services/socket_service.dart';
import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/api/api_client.dart';

class PickUpCustomerProvider extends ChangeNotifier {
  late final PickUpCustomerService _pickUpCustomerService;
  late final SocketService _socketService;

  bool isLoading = false;
  String? successMessage;
  String? errorMessage;
  OptimizedRoute? optimizedRoute;

  PickUpCustomerProvider() {
    _pickUpCustomerService = PickUpCustomerService(ApiClient());
    _socketService = SocketService();
    _socketService.initializeSocket();
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
  /// Pass the trip ID from the optimized route response (_id field)
  /// Also broadcasts trip started event via WebSocket to parents
  Future<bool> updateTripStatus({
    required String tripId,
    required String tripStatus,
  }) async {
    try {
      isLoading = true;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _pickUpCustomerService.updateTripStatus(
        tripId: tripId,
        tripStatus: tripStatus,
      );

      if (response.success && response.data != null) {
        successMessage = response.message ?? 'Trip status updated successfully';

        if (tripStatus == TripStatus.started.value) {
          _socketService.startTripViaWebSocket(tripId);
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

  Future<bool> updateDriverPosition({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
  }) async {
    try {
      _socketService.updateDriverPosition(
        tripId: tripId,
        latitude: latitude,
        longitude: longitude,
        speed: speed,
        heading: heading,
        accuracy: accuracy,
      );

      final response = await _pickUpCustomerService.updateDriverPosition(
        tripId: tripId,
        latitude: latitude,
        longitude: longitude,
        speed: speed,
        heading: heading,
        accuracy: accuracy,
      );

      return response.success;
    } catch (e) {
      return false;
    }
  }
}
