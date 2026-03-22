import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/models/user_details/user_details_update_request.dart';
import 'package:skolo_driver/api/models/user_details/user_details_update_response.dart';
import 'package:skolo_driver/data/datasources/local/storage_service.dart';

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

  /// Update driver availability
  /// PATCH /driver/availability
  Future<Map<String, dynamic>> updateDriverAvailability(
      bool isAvailable) async {
    final response = await _apiClient.patch(
      Endpoints.driverAvailability,
      body: {'is_available': isAvailable},
    );
    return _handleMutationResponse(
      response,
      'Driver availability updated successfully',
      'Failed to update driver availability',
    );
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

  /// Upload file to shared upload service
  /// POST/PUT /shared/upload?folder_path={folderPath}
  Future<Map<String, dynamic>> uploadSharedFile({
    required File file,
    required String folderPath,
    String? oldFileUrl,
  }) async {
    try {
      final uri = Uri.parse(Endpoints.sharedUpload).replace(
        queryParameters: {'folder_path': folderPath},
      );

      final method =
          (oldFileUrl != null && oldFileUrl.isNotEmpty) ? 'PUT' : 'POST';
      final request = http.MultipartRequest(method, uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      if (method == 'PUT') {
        request.fields['old_file_url'] = oldFileUrl!;
      }

      final token = await StorageService().getAuthToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];
        final url = data is Map<String, dynamic>
            ? (data['url'] ?? data['file_url'] ?? data['photo_url'])
            : data;

        if (url is String && url.isNotEmpty) {
          return {
            'success': true,
            'url': url,
            'message': jsonResponse['message'] ?? 'File uploaded successfully',
          };
        }

        return {
          'success': false,
          'message':
              jsonResponse['message'] ?? 'Upload succeeded but URL missing',
        };
      }

      final jsonResponse = jsonDecode(response.body);
      return {
        'success': false,
        'message': jsonResponse['message'] ?? 'Failed to upload file',
        'error': jsonResponse['error'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to upload file',
        'error': e.toString(),
      };
    }
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
