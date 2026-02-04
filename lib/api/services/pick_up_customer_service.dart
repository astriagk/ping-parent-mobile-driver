import 'dart:convert';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_request.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/trip_status_request.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/trip_status_response.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/position_update_request.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/position_update_response.dart';

class PickUpCustomerService {
  final ApiClient _apiClient;

  PickUpCustomerService(this._apiClient);

  /// Fetch optimized route from TomTom tracking API
  Future<OptimizedRouteResponse> fetchOptimizedRoute({
    required String tripId,
    required double currentLatitude,
    required double currentLongitude,
  }) async {
    try {
      final request = OptimizedRouteRequest(
        tripId: tripId,
        currentLatitude: currentLatitude,
        currentLongitude: currentLongitude,
      );

      final response = await _apiClient.post(
        Endpoints.trackingTomTom,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          return OptimizedRouteResponse.fromJson(jsonData);
        } catch (parseError) {
          return OptimizedRouteResponse(
            success: false,
            data: null,
            message: 'Error parsing route response: ${parseError.toString()}',
          );
        }
      } else {
        return OptimizedRouteResponse(
          success: false,
          data: null,
          message: 'Failed to fetch route. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return OptimizedRouteResponse(
        success: false,
        data: null,
        message: 'Error fetching route: ${e.toString()}',
      );
    }
  }

  /// Update trip status (e.g., "started", "completed")
  /// Takes the trip ID from the optimized route (_id field) and trip status
  Future<TripStatusResponse> updateTripStatus({
    required String tripId,
    required String tripStatus,
  }) async {
    try {
      final request = TripStatusRequest(tripStatus: tripStatus);

      final response = await _apiClient.patch(
        Endpoints.updateTripStatus(tripId),
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          return TripStatusResponse.fromJson(jsonData);
        } catch (parseError) {
          return TripStatusResponse(
            success: false,
            data: null,
            message:
                'Error parsing trip status response: ${parseError.toString()}',
          );
        }
      } else {
        return TripStatusResponse(
          success: false,
          data: null,
          message:
              'Failed to update trip status. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return TripStatusResponse(
        success: false,
        data: null,
        message: 'Error updating trip status: ${e.toString()}',
      );
    }
  }

  /// Update driver position for tracking
  Future<PositionUpdateResponse> updateDriverPosition({
    required String tripId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required double accuracy,
  }) async {
    try {
      final request = PositionUpdateRequest(
        latitude: latitude,
        longitude: longitude,
        speed: speed,
        heading: heading,
        accuracy: accuracy,
      );

      final response = await _apiClient.patch(
        Endpoints.updateDriverPosition(tripId),
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          return PositionUpdateResponse.fromJson(jsonData);
        } catch (parseError) {
          return PositionUpdateResponse(
            success: false,
            data: null,
            message:
                'Error parsing position update response: ${parseError.toString()}',
          );
        }
      } else {
        return PositionUpdateResponse(
          success: false,
          data: null,
          message: 'Failed to update position. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PositionUpdateResponse(
        success: false,
        data: null,
        message: 'Error updating position: ${e.toString()}',
      );
    }
  }
}
