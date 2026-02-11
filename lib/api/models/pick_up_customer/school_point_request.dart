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
