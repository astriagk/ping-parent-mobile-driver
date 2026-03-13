class SchoolPointRequest {
  final List<String> studentIds;
  final double latitude;
  final double longitude;
  final String? schoolId;

  /// Optional: Student IDs that were skipped/absent (for both PICKUP and DROP trips)
  final List<String>? skippedStudentIds;

  SchoolPointRequest({
    required this.studentIds,
    required this.latitude,
    required this.longitude,
    this.schoolId,
    this.skippedStudentIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'student_ids': studentIds,
      'latitude': latitude,
      'longitude': longitude,
    };
    // Include school_id if provided (for multi-school validation)
    if (schoolId != null) {
      json['school_id'] = schoolId;
    }
    // Only include skipped_student_ids if provided
    if (skippedStudentIds != null && skippedStudentIds!.isNotEmpty) {
      json['skipped_student_ids'] = skippedStudentIds;
    }
    return json;
  }
}
