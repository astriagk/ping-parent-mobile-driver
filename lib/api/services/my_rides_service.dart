import 'dart:convert';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/endpoints.dart';
import 'package:taxify_driver_ui/api/models/my_rides_response.dart';

class MyRidesService {
  final ApiClient _apiClient;

  MyRidesService(this._apiClient);

  /// Get driver-student assignments with parent request status
  /// GET /driver-student-assignments/driver/my-parent-requested
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
}
