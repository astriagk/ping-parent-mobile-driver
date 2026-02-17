class SchoolPointRequest {
  final List<String> studentIds;
  final double latitude;
  final double longitude;

  /// Optional: Student IDs that were skipped/absent (for both PICKUP and DROP trips)
  final List<String>? skippedStudentIds;

  SchoolPointRequest({
    required this.studentIds,
    required this.latitude,
    required this.longitude,
    this.skippedStudentIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
    // Only include student_ids if not empty
    if (studentIds.isNotEmpty) {
      json['student_ids'] = studentIds;
    }
    // Only include skipped_student_ids if provided
    if (skippedStudentIds != null && skippedStudentIds!.isNotEmpty) {
      json['skipped_student_ids'] = skippedStudentIds;
    }
    return json;
  }
}
