import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/index.dart';

class OnboardingService {
  final ApiClient _apiClient;

  OnboardingService(this._apiClient);

  /// Create or update driver profile
  Future<DriverProfileResponse> createDriverProfile({
    required String name,
    required String email,
    required String photoUrl,
    required String vehicleType,
    required String vehicleNumber,
    required int vehicleCapacity,
    required bool isAvailable,
  }) async {
    try {
      final request = DriverProfileRequest(
        name: name,
        email: email,
        photoUrl: photoUrl,
        vehicleType: vehicleType,
        vehicleNumber: vehicleNumber,
        vehicleCapacity: vehicleCapacity,
        isAvailable: isAvailable,
      );

      final response = await _apiClient.post(
        Endpoints.driverProfile,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DriverProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorResponse =
              DriverProfileResponse.fromJson(jsonDecode(response.body));
          return errorResponse;
        } catch (_) {
          return DriverProfileResponse(
            success: false,
            error:
                'Failed to create driver profile. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return DriverProfileResponse(
        success: false,
        error: 'Error creating driver profile: ${e.toString()}',
      );
    }
  }

  /// Upload driver documents
  Future<DriverDocumentsResponse> uploadDriverDocuments({
    required String drivingLicenseNumber,
    required String drivingLicensePhotoUrl,
    required String vehicleLicenseNumber,
    required String vehicleLicensePhotoUrl,
    required String insuranceNumber,
    required String insurancePhotoUrl,
  }) async {
    try {
      final request = DriverDocumentsRequest(
        drivingLicenseNumber: drivingLicenseNumber,
        drivingLicensePhotoUrl: drivingLicensePhotoUrl,
        vehicleLicenseNumber: vehicleLicenseNumber,
        vehicleLicensePhotoUrl: vehicleLicensePhotoUrl,
        insuranceNumber: insuranceNumber,
        insurancePhotoUrl: insurancePhotoUrl,
      );

      final response = await _apiClient.post(
        Endpoints.driverDocuments,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DriverDocumentsResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorResponse =
              DriverDocumentsResponse.fromJson(jsonDecode(response.body));
          return errorResponse;
        } catch (_) {
          return DriverDocumentsResponse(
            success: false,
            error:
                'Failed to upload driver documents. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return DriverDocumentsResponse(
        success: false,
        error: 'Error uploading driver documents: ${e.toString()}',
      );
    }
  }
}
