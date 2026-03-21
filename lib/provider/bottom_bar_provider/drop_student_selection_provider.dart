import 'package:flutter/material.dart';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/api/models/drop_student_selection_model.dart';
import 'package:skolo_driver/api/models/pick_up_customer/trip_status_response.dart';
import 'package:skolo_driver/api/services/drop_student_selection_service.dart';
import 'package:skolo_driver/api/services/pick_up_customer_service.dart';
import 'package:skolo_driver/services/location/location_service.dart';
import 'package:skolo_driver/api/models/pick_up_customer/school_point_request.dart';

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
        _attendanceMap[student.studentId] = student.isMarkedPresent;
      }
    }
    notifyListeners();
  }

  /// Toggle student attendance status
  void toggleStudentAttendance(String studentId) {
    if (_attendanceMap.containsKey(studentId)) {
      _attendanceMap[studentId] = !_attendanceMap[studentId]!;

      // Update the student object as well
      for (var parent in _parentsWithStudents) {
        for (var student in parent.students) {
          if (student.studentId == studentId) {
            student.isMarkedPresent = _attendanceMap[studentId]!;
            break;
          }
        }
      }
      notifyListeners();
    }
  }

  /// Check if a student is marked present
  bool isStudentPresent(String studentId) {
    return _attendanceMap[studentId] ?? false;
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

  /// Get unique school IDs from all students, in order of first appearance
  /// Used by DropStudentSelectionScreen to iterate through schools sequentially
  List<String> getUniqueSchoolIds() {
    final seen = <String>{};
    final ordered = <String>[];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.schoolId != null && seen.add(student.schoolId!)) {
          ordered.add(student.schoolId!);
        }
      }
    }
    return ordered;
  }

  /// Get skipped (unselected) student IDs filtered by school
  /// For multi-school routes, only returns skipped students from the specified school
  List<String> getSkippedStudentIdsForSchool(String schoolId) {
    List<String> skippedIds = [];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.schoolId == schoolId && !student.isMarkedPresent) {
          skippedIds.add(student.studentId);
        }
      }
    }
    return skippedIds;
  }

  /// Filter students by school_id for multi-school routes
  /// Returns list of students belonging to specified school
  List<TripStudent> getStudentsForSchool(String? schoolId) {
    if (schoolId == null) {
      // If no school_id specified, return all students
      List<TripStudent> allStudents = [];
      for (var parent in _parentsWithStudents) {
        allStudents.addAll(parent.students);
      }
      return allStudents;
    }

    List<TripStudent> schoolStudents = [];
    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.schoolId == schoolId) {
          schoolStudents.add(student);
        }
      }
    }
    return schoolStudents;
  }

  /// Validate if a student belongs to a specific school
  /// Returns true if student's school_id matches the specified schoolId
  bool validateStudentBelongsToSchool(String studentId, String? schoolId) {
    if (schoolId == null) return true;

    for (var parent in _parentsWithStudents) {
      for (var student in parent.students) {
        if (student.studentId == studentId) {
          return student.schoolId == schoolId;
        }
      }
    }
    return false;
  }

  /// Get selected student IDs filtered by school (for current waypoint)
  List<String> getSelectedStudentIdsForSchool(String? schoolId) {
    final schoolStudents = getStudentsForSchool(schoolId);
    return schoolStudents
        .where((student) => student.isMarkedPresent)
        .map((student) => student.studentId)
        .toList();
  }

  /// Mark selected students as picked from school
  /// POST /trip-students/trip/:tripId/school-point
  /// Gets current location and sends selected student IDs
  /// [schoolId] - Optional: school being processed (for multi-school routes)
  Future<SchoolPointResponse> markSchoolPoint({String? schoolId}) async {
    if (_currentTripId == null) {
      return SchoolPointResponse(
        success: false,
        data: null,
        message: 'No trip ID set',
      );
    }

    // Check if there are selected students (for this school if multi-school)
    final hasSelected = schoolId != null
        ? getSelectedStudentIdsForSchool(schoolId).isNotEmpty
        : hasSelectedStudents();
    if (!hasSelected) {
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

      // Get selected student IDs (filter by school if provided)
      final studentIds = schoolId != null
          ? getSelectedStudentIdsForSchool(schoolId)
          : getSelectedStudentIdsForApi();

      // Get skipped (unselected) student IDs for DROP trip
      // For multi-school routes, only get skipped students from the current school
      final skippedStudentIds = schoolId != null
          ? getSkippedStudentIdsForSchool(schoolId)
          : getSkippedStudentIdsForApi();

      // Create request with skipped students and school_id
      final request = SchoolPointRequest(
        studentIds: studentIds,
        latitude: location.latitude,
        longitude: location.longitude,
        schoolId: schoolId,
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
