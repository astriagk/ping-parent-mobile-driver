import 'dart:convert';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/models/documents/driver_documents_response.dart';
import 'package:taxify_driver_ui/api/models/documents/driver_documents_request.dart';

class DocumentUpdateService {
  final ApiClient _apiClient;
  final Map<String, String> _jsonHeaders = {'Content-Type': 'application/json'};

  DocumentUpdateService(this._apiClient);

  /// Get driver documents
  /// GET /driver/documents
  Future<DriverDocumentsResponse> getDriverDocuments() async {
    final response = await _apiClient.get(Endpoints.driverDocuments);
    return _handleQueryResponse(response);
  }

  /// Update driver documents
  /// PUT /driver/documents
  Future<Map<String, dynamic>> updateDriverDocuments(
      DriverDocumentsRequest request) async {
    final response = await _apiClient.put(
      Endpoints.driverDocuments,
      headers: _jsonHeaders,
      body: jsonEncode(request.toJson()),
    );
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
