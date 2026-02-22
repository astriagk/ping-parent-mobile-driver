/// Model for a student in drop trip
class TripStudent {
  final String id;
  final String studentId;
  final String studentName;
  final String? studentClass;
  final String? studentSection;
  final String? studentGender;
  final String? studentPhotoUrl;
  final int sequenceOrder;
  final String attendanceStatus;
  final String pickupStatus;

  /// Local state for attendance marking
  bool isMarkedPresent;

  TripStudent({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.studentClass,
    this.studentSection,
    this.studentGender,
    this.studentPhotoUrl,
    required this.sequenceOrder,
    required this.attendanceStatus,
    required this.pickupStatus,
    this.isMarkedPresent = false,
  });

  factory TripStudent.fromJson(Map<String, dynamic> json) {
    return TripStudent(
      id: json['_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'],
      studentSection: json['student_section'],
      studentGender: json['student_gender'],
      studentPhotoUrl: json['student_photo_url'],
      sequenceOrder: json['sequence_order'] ?? 0,
      attendanceStatus: json['attendance_status'] ?? 'pending',
      pickupStatus: json['pickup_status'] ?? 'pending',
      isMarkedPresent: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student_id': studentId,
      'student_name': studentName,
      'student_class': studentClass,
      'student_section': studentSection,
      'student_gender': studentGender,
      'student_photo_url': studentPhotoUrl,
      'sequence_order': sequenceOrder,
      'attendance_status': attendanceStatus,
      'pickup_status': pickupStatus,
    };
  }

  /// Get class display string
  String get classDisplay {
    if (studentClass != null && studentSection != null) {
      return '$studentClass - $studentSection';
    } else if (studentClass != null) {
      return studentClass!;
    }
    return '';
  }
}

/// Model for parent with their students
class ParentWithStudents {
  final String parentId;
  final String parentName;
  final String parentPhoneNumber;
  final String? parentPhotoUrl;
  final List<TripStudent> students;

  ParentWithStudents({
    required this.parentId,
    required this.parentName,
    required this.parentPhoneNumber,
    this.parentPhotoUrl,
    required this.students,
  });

  factory ParentWithStudents.fromJson(Map<String, dynamic> json) {
    var studentsList = <TripStudent>[];
    if (json['students'] is List) {
      studentsList = (json['students'] as List)
          .map((student) =>
              TripStudent.fromJson(student as Map<String, dynamic>))
          .toList();
    }

    return ParentWithStudents(
      parentId: json['parent_id'] ?? '',
      parentName: json['parent_name'] ?? '',
      parentPhoneNumber: json['parent_phone_number'] ?? '',
      parentPhotoUrl: json['parent_photo_url'],
      students: studentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'parent_name': parentName,
      'parent_phone_number': parentPhoneNumber,
      'parent_photo_url': parentPhotoUrl,
      'students': students.map((s) => s.toJson()).toList(),
    };
  }
}

/// Response model for getting drop students grouped by parent
class DropStudentSelectionResponse {
  final bool success;
  final List<ParentWithStudents> data;
  final String? message;

  DropStudentSelectionResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory DropStudentSelectionResponse.fromJson(Map<String, dynamic> json) {
    var parentsList = <ParentWithStudents>[];
    if (json['data'] is List) {
      parentsList = (json['data'] as List)
          .map((parent) =>
              ParentWithStudents.fromJson(parent as Map<String, dynamic>))
          .toList();
    }

    return DropStudentSelectionResponse(
      success: json['success'] ?? false,
      data: parentsList,
      message: json['message'],
    );
  }

  /// Parse directly from API response list (when response is just the array)
  static List<ParentWithStudents> parseFromList(List<dynamic> jsonList) {
    return jsonList
        .map((parent) =>
            ParentWithStudents.fromJson(parent as Map<String, dynamic>))
        .toList();
  }
}

/// Request model for school point action (pick from school for drop trips)
class SchoolPointRequest {
  final List<String> studentIds;
  final double latitude;
  final double longitude;

  /// Optional: Student IDs that were skipped/absent (only for DROP trips)
  final List<String>? skippedStudentIds;

  SchoolPointRequest({
    required this.studentIds,
    required this.latitude,
    required this.longitude,
    this.skippedStudentIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'student_ids': studentIds,
      'latitude': latitude,
      'longitude': longitude,
    };
    // Only include skipped_student_ids if provided (for DROP trips)
    if (skippedStudentIds != null && skippedStudentIds!.isNotEmpty) {
      json['skipped_student_ids'] = skippedStudentIds;
    }
    return json;
  }
}

/// Response model for school point action
class SchoolPointResponse {
  final bool success;
  final SchoolPointData? data;
  final String? message;

  SchoolPointResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SchoolPointResponse.fromJson(Map<String, dynamic> json) {
    return SchoolPointResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? SchoolPointData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'],
    );
  }
}

/// Data model for school point action response
class SchoolPointData {
  final String tripType;
  final String action;
  final List<String> processedStudents;
  final List<String> skippedStudents;
  final List<String> failedStudents;

  SchoolPointData({
    required this.tripType,
    required this.action,
    required this.processedStudents,
    required this.skippedStudents,
    required this.failedStudents,
  });

  factory SchoolPointData.fromJson(Map<String, dynamic> json) {
    return SchoolPointData(
      tripType: json['trip_type'] ?? '',
      action: json['action'] ?? '',
      processedStudents: (json['processed_students'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      skippedStudents: (json['skipped_students'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      failedStudents: (json['failed_students'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
