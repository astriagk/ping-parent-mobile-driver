import 'dart:convert';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_model.dart';
import 'package:taxify_driver_ui/api/models/pick_up_customer/optimized_route_request.dart';

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
}
