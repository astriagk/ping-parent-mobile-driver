import 'package:flutter/material.dart';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/api/models/drop_student_selection_model.dart';
import 'package:skolo_driver/api/models/pick_up_customer/trip_status_response.dart';
import 'package:skolo_driver/api/services/drop_student_selection_service.dart';
import 'package:skolo_driver/api/services/pick_up_customer_service.dart';
import 'package:skolo_driver/helper/location_service.dart';

/// Provider for managing drop student selection/attendance
class DropStudentSelectionProvider extends ChangeNotifier {
  // Trip data
  String? _currentTripId;

  // Parent-student data from API
  List<ParentWithStudents> _parentsWithStudents = [];

  // Attendance tracking: student _id -> isMarkedPresent
  Map<String, bool> _attendanceMap = {};

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get currentTripId => _currentTripId;
  List<ParentWithStudents> get parentsWithStudents => _parentsWithStudents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Set current trip ID (called from active_ride_screen)
  /// [tripId] - the _id field of the trip
  void setCurrentTripId(String tripId) {
    _currentTripId = tripId;
    notifyListeners();
  }

  /// Set parents with students from API response
  void setParentsWithStudents(List<ParentWithStudents> parents) {
    _parentsWithStudents = parents;
    // Initialize attendance map for all students
    _attendanceMap = {};
    for (var parent in parents) {
      for (var student in parent.students) {
        _attendanceMap[student.id] = student.isMarkedPresent;
      }
    }
    notifyListeners();
  }

  /// Toggle student attendance status
  void toggleStudentAttendance(String tripStudentId) {
    if (_attendanceMap.containsKey(tripStudentId)) {
      _attendanceMap[tripStudentId] = !_attendanceMap[tripStudentId]!;

      // Update the student object as well
      for (var parent in _parentsWithStudents) {
        for (var student in parent.students) {
          if (student.id == tripStudentId) {
            student.isMarkedPresent = _attendanceMap[tripStudentId]!;
            break;
          }
        }
      }
      notifyListeners();
    }
  }

  /// Check if a student is marked present
  bool isStudentPresent(String tripStudentId) {
    return _attendanceMap[tripStudentId] ?? false;
  }

  /// Get all selected (present) trip student IDs
  List<String> getSelectedTripStudentIds() {
    return _attendanceMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all selected (present) students
  List<TripStudent> getSelectedStudents() {
    List<TripStudent> selected = [];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.isMarkedPresent) {
          selected.add(student);
        }
      }
    }
    return selected;
  }

  /// Get count of selected students
  int get selectedStudentCount => getSelectedTripStudentIds().length;

  /// Get total student count
  int get totalStudentCount {
    int total = 0;
    for (var parent in _parentsWithStudents) {
      total += parent.students.length;
    }
    return total;
  }

  /// Check if at least one student is selected
  bool hasSelectedStudents() {
    return _attendanceMap.values.any((isPresent) => isPresent);
  }

  /// Fetch trip students grouped by parent from API
  /// GET /trip-students/trip/:tripId/grouped-by-parent
  Future<bool> fetchTripStudentsGroupedByParent(String tripId) async {
    _isLoading = true;
    _errorMessage = null;
    _currentTripId = tripId;
    notifyListeners();

    try {
      final service = DropStudentSelectionService(ApiClient());
      final response = await service.getTripStudentsGroupedByParent(tripId);

      if (response.success && response.data.isNotEmpty) {
        setParentsWithStudents(response.data);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'No students found for this trip';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error fetching students: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get selected student IDs (studentId FK, not trip student _id)
  List<String> getSelectedStudentIdsForApi() {
    List<String> studentIds = [];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.isMarkedPresent) {
          studentIds.add(student.studentId);
        }
      }
    }
    return studentIds;
  }

  /// Get skipped (unselected) student IDs for DROP trips
  /// These are students who were not picked up from school
  List<String> getSkippedStudentIdsForApi() {
    List<String> skippedIds = [];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (!student.isMarkedPresent) {
          skippedIds.add(student.studentId);
        }
      }
    }
    return skippedIds;
  }

  /// Mark selected students as picked from school
  /// POST /trip-students/trip/:tripId/school-point
  /// Gets current location and sends selected student IDs
  Future<SchoolPointResponse> markSchoolPoint() async {
    if (_currentTripId == null) {
      return SchoolPointResponse(
        success: false,
        data: null,
        message: 'No trip ID set',
      );
    }

    if (!hasSelectedStudents()) {
      return SchoolPointResponse(
        success: false,
        data: null,
        message: 'No students selected',
      );
    }

    _errorMessage = null;

    try {
      // Get current driver location
      final location = await LocationService.getCurrentLocation();
      if (location == null) {
        _errorMessage = 'Unable to get current location';
        notifyListeners();
        return SchoolPointResponse(
          success: false,
          data: null,
          message: 'Unable to get current location',
        );
      }

      // Get selected student IDs
      final studentIds = getSelectedStudentIdsForApi();

      // Get skipped (unselected) student IDs for DROP trip
      final skippedStudentIds = getSkippedStudentIdsForApi();

      // Create request with skipped students
      final request = SchoolPointRequest(
        studentIds: studentIds,
        latitude: location.latitude,
        longitude: location.longitude,
        skippedStudentIds:
            skippedStudentIds.isNotEmpty ? skippedStudentIds : null,
      );

      // Call API
      final service = DropStudentSelectionService(ApiClient());
      final response = await service.markSchoolPoint(
        tripId: _currentTripId!,
        request: request,
      );

      if (!response.success) {
        _errorMessage = response.message;
        notifyListeners();
      }

      return response;
    } catch (e) {
      _errorMessage = 'Error marking school point: ${e.toString()}';
      notifyListeners();
      return SchoolPointResponse(
        success: false,
        data: null,
        message: 'Error marking school point: ${e.toString()}',
      );
    }
  }

  /// Reset selection
  void resetSelection() {
    _attendanceMap.clear();
    _parentsWithStudents.clear();
    _currentTripId = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Update trip status (e.g., "started", "in_progress", "completed")
  Future<TripStatusResponse?> updateTripStatus({
    required String tripId,
    required String tripStatus,
  }) async {
    try {
      final service = PickUpCustomerService(ApiClient());
      final response = await service.updateTripStatus(
        tripId: tripId,
        tripStatus: tripStatus,
      );
      return response;
    } catch (e) {
      _errorMessage = 'Error updating trip status: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
}
