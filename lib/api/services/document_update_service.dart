import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/models/documents/driver_documents_response.dart';
import 'package:skolo_driver/data/datasources/local/storage_service.dart';

class DocumentUpdateService {
  final ApiClient _apiClient;

  DocumentUpdateService(this._apiClient);

  /// Get driver documents
  /// GET /driver/documents
  Future<DriverDocumentsResponse> getDriverDocuments() async {
    final response = await _apiClient.get(Endpoints.driverDocuments);
    return _handleQueryResponse(response);
  }

  /// Update driver documents
  /// PUT /driver/documents
  Future<Map<String, dynamic>> updateDriverDocuments({
    required String drivingLicenseNumber,
    required String vehicleLicenseNumber,
    required String insuranceNumber,
    File? drivingLicenseImage,
    File? vehicleLicenseImage,
    File? insuranceImage,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(Endpoints.driverDocuments),
    );

    request.fields['driving_license_number'] = drivingLicenseNumber;
    request.fields['vehicle_license_number'] = vehicleLicenseNumber;
    request.fields['insurance_number'] = insuranceNumber;

    if (drivingLicenseImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'driving_license_photo',
          drivingLicenseImage.path,
        ),
      );
    }

    if (vehicleLicenseImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'vehicle_license_photo',
          vehicleLicenseImage.path,
        ),
      );
    }

    if (insuranceImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'insurance_photo',
          insuranceImage.path,
        ),
      );
    }

    final token = await StorageService().getAuthToken();
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleMutationResponse(
      response,
      'Driver documents updated successfully',
      'Failed to update driver documents',
    );
  }

  /// Handle query response (GET)
  DriverDocumentsResponse _handleQueryResponse(dynamic response) {
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return DriverDocumentsResponse.fromJson(jsonResponse);
      } else {
        return DriverDocumentsResponse(
          success: false,
          data: null,
          message: 'Failed to fetch driver documents',
        );
      }
    } catch (e) {
      return DriverDocumentsResponse(
        success: false,
        data: null,
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
