import 'dart:convert';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/models/my_rides_response.dart';
import 'package:skolo_driver/api/enums/assignment_status_enum.dart';

class MyRidesService {
  final ApiClient _apiClient;

  MyRidesService(this._apiClient);

  /// Get driver-student assignments with parent request status
  /// GET /driver/assignments/parent-requested
  Future<MyRidesResponse> getDriverStudentAssignments({
    String assignmentStatus = 'pending',
  }) async {
    try {
      final url =
          '${Endpoints.driverStudentAssignments}?assignment_status=$assignmentStatus';
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return MyRidesResponse.fromJson(jsonResponse);
      } else {
        return MyRidesResponse(
          success: false,
          data: [],
          message: 'Failed to fetch driver-student assignments',
        );
      }
    } catch (e) {
      return MyRidesResponse(
        success: false,
        data: [],
        message: 'Error: ${e.toString()}',
      );
    }
  }

  /// Approve or Reject driver-student assignment
  /// POST /driver/assignments/:id/approve or /driver/assignments/:id/reject
  Future<Map<String, dynamic>> approveOrRejectAssignment({
    required String assignmentId,
    required AssignmentStatus status,
  }) async {
    try {
      final endpoint =
          status == AssignmentStatus.approved ? 'approve' : 'reject';
      final url = Endpoints.approveAssignment(assignmentId, endpoint);

      final response = await _apiClient.post(url, body: {});

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'success': jsonResponse['success'] ?? false,
          'data': jsonResponse['data'],
          'message': jsonResponse['message'] ?? '',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message':
              'Failed to ${status == AssignmentStatus.approved ? 'approve' : 'reject'} assignment',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
