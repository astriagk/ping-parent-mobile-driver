class SchoolPointResponse {
  final bool success;
  final SchoolPointData? data;
  final String? message;
  final String? error;
  final List<String>? details;

  SchoolPointResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.details,
  });

  factory SchoolPointResponse.fromJson(Map<String, dynamic> json) {
    return SchoolPointResponse(
      success: json['success'] ?? false,
      data:
          json['data'] != null ? SchoolPointData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
      details:
          json['details'] != null ? List<String>.from(json['details']) : null,
    );
  }
}

class SchoolPointData {
  final String tripType;
  final String action;
  final List<String> processedStudents;
  final List<FailedSchoolStudent> failedStudents;

  SchoolPointData({
    required this.tripType,
    required this.action,
    required this.processedStudents,
    required this.failedStudents,
  });

  factory SchoolPointData.fromJson(Map<String, dynamic> json) {
    return SchoolPointData(
      tripType: json['trip_type'] ?? '',
      action: json['action'] ?? '',
      processedStudents: List<String>.from(json['processed_students'] ?? []),
      failedStudents: (json['failed_students'] as List?)
              ?.map((e) => FailedSchoolStudent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FailedSchoolStudent {
  final String studentId;
  final String reason;

  FailedSchoolStudent({
    required this.studentId,
    required this.reason,
  });

  factory FailedSchoolStudent.fromJson(Map<String, dynamic> json) {
    return FailedSchoolStudent(
      studentId: json['student_id'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
