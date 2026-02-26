import 'dart:convert';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/api/endpoints.dart';
import 'package:skolo_driver/api/models/drop_student_selection_model.dart';

/// Service for drop student selection API calls
class DropStudentSelectionService {
  final ApiClient _apiClient;

  DropStudentSelectionService(this._apiClient);

  /// Fetch trip students grouped by parent
  /// GET /trip-students/trip/:tripId/grouped-by-parent
  ///
  /// Parameters:
  ///   - tripId: The trip ID to fetch students for
  ///
  /// Returns:
  ///   - DropStudentSelectionResponse with list of parents and their students
  Future<DropStudentSelectionResponse> getTripStudentsGroupedByParent(
      String tripId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.tripStudentsGroupedByParent(tripId),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return DropStudentSelectionResponse.fromJson(jsonResponse);
      } else {
        return DropStudentSelectionResponse(
          success: false,
          data: [],
          message: 'Failed to fetch students. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return DropStudentSelectionResponse(
        success: false,
        data: [],
        message: 'Error fetching students: ${e.toString()}',
      );
    }
  }

  /// Mark students as picked from school (for drop trips)
  /// POST /trip-students/trip/:tripId/school-point
  ///
  /// Parameters:
  ///   - tripId: The trip ID
  ///   - request: SchoolPointRequest with student IDs and driver location
  ///
  /// Returns:
  ///   - SchoolPointResponse with processed and failed students
  Future<SchoolPointResponse> markSchoolPoint({
    required String tripId,
    required SchoolPointRequest request,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.schoolPoint(tripId),
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return SchoolPointResponse.fromJson(jsonResponse);
      } else {
        return SchoolPointResponse(
          success: false,
          data: null,
          message:
              'Failed to mark school point. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SchoolPointResponse(
        success: false,
        data: null,
        message: 'Error marking school point: ${e.toString()}',
      );
    }
  }
}
