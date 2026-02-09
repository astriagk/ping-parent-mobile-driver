class PickupPointResponse {
  final bool success;
  final PickupPointData? data;
  final String? message;
  final String? error;

  PickupPointResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory PickupPointResponse.fromJson(Map<String, dynamic> json) {
    return PickupPointResponse(
      success: json['success'] ?? false,
      data:
          json['data'] != null ? PickupPointData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class PickupPointData {
  final String tripType;
  final List<String> processedStudents;
  final List<String> absentStudents;
  final List<FailedStudent> failedStudents;

  PickupPointData({
    required this.tripType,
    required this.processedStudents,
    required this.absentStudents,
    required this.failedStudents,
  });

  factory PickupPointData.fromJson(Map<String, dynamic> json) {
    return PickupPointData(
      tripType: json['trip_type'] ?? '',
      processedStudents: List<String>.from(json['processed_students'] ?? []),
      absentStudents: List<String>.from(json['absent_students'] ?? []),
      failedStudents: (json['failed_students'] as List?)
              ?.map((e) => FailedStudent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class FailedStudent {
  final String studentId;
  final String reason;

  FailedStudent({
    required this.studentId,
    required this.reason,
  });

  factory FailedStudent.fromJson(Map<String, dynamic> json) {
    return FailedStudent(
      studentId: json['student_id'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
