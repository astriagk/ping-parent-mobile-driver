import 'dart:convert';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/models/user_details/user_details_update_request.dart';
import 'package:taxify_driver_ui/api/models/user_details/user_details_update_response.dart';

class UserDetailsService {
  final ApiClient _apiClient;
  final Map<String, String> _jsonHeaders = {'Content-Type': 'application/json'};

  UserDetailsService(this._apiClient);

  /// Get driver profile
  /// GET /driver/profile
  Future<UserDetailsUpdateResponse> getDriverProfile() async {
    final response = await _apiClient.get(Endpoints.driverProfile);
    return _handleQueryResponse(response);
  }

  /// Update driver profile
  /// PUT /driver/profile
  Future<Map<String, dynamic>> updateDriverProfile(
      UserDetailsUpdateRequest request) async {
    final response = await _apiClient.put(
      Endpoints.updateDriverProfile,
      headers: _jsonHeaders,
      body: request.toJsonString(),
    );
    return _handleMutationResponse(
      response,
      'Driver profile updated successfully',
      'Failed to update driver profile',
    );
  }

  /// Handle query response (GET)
  UserDetailsUpdateResponse _handleQueryResponse(dynamic response) {
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return UserDetailsUpdateResponse.fromJson(jsonResponse);
      } else {
        return UserDetailsUpdateResponse(
          success: false,
          data: DriverProfileData(
            id: '',
            userId: '',
            driverUniqueId: '',
            name: '',
            email: '',
            phoneNumber: '',
            vehicleType: '',
            vehicleNumber: '',
            vehicleCapacity: 0,
            currentStudentCount: 0,
            approvalStatus: '',
            isAvailable: false,
            rating: 0,
            totalTrips: 0,
            createdAt: '',
            updatedAt: '',
          ),
          message: 'Failed to fetch driver profile',
        );
      }
    } catch (e) {
      return UserDetailsUpdateResponse(
        success: false,
        data: DriverProfileData(
          id: '',
          userId: '',
          driverUniqueId: '',
          name: '',
          email: '',
          phoneNumber: '',
          vehicleType: '',
          vehicleNumber: '',
          vehicleCapacity: 0,
          currentStudentCount: 0,
          approvalStatus: '',
          isAvailable: false,
          rating: 0,
          totalTrips: 0,
          createdAt: '',
          updatedAt: '',
        ),
        message: 'Error: ${e.toString()}',
      );
    }
  }

  /// Handle mutation response (POST, PUT, PATCH, DELETE)
  Map<String, dynamic> _handleMutationResponse(
    dynamic response,
    String successMessage,
    String errorMessage,
  ) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': jsonResponse['success'] ?? false,
          'data': jsonResponse['data'],
          'message': jsonResponse['message'] ?? successMessage,
        };
      } else {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': jsonResponse['message'] ?? errorMessage,
          'error': jsonResponse['error'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }
}
