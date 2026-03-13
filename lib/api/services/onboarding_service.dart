import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_client.dart';
import '../endpoints.dart';
import '../models/index.dart';
import 'storage_service.dart';

class OnboardingService {
  final ApiClient _apiClient;

  OnboardingService(this._apiClient);

  /// Create or update driver profile
  Future<DriverProfileResponse> createDriverProfile({
    required String name,
    required String email,
    String? photoUrl,
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
    required File drivingLicenseImage,
    required String vehicleLicenseNumber,
    required File vehicleLicenseImage,
    required String insuranceNumber,
    required File insuranceImage,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.driverDocuments),
      );

      // Add text fields
      request.fields['driving_license_number'] = drivingLicenseNumber;
      request.fields['vehicle_license_number'] = vehicleLicenseNumber;
      request.fields['insurance_number'] = insuranceNumber;

      // Add image files
      request.files.add(
        await http.MultipartFile.fromPath(
          'driving_license_photo',
          drivingLicenseImage.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'vehicle_license_photo',
          vehicleLicenseImage.path,
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'insurance_photo',
          insuranceImage.path,
        ),
      );

      // Add auth headers
      final token = await StorageService().getAuthToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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
