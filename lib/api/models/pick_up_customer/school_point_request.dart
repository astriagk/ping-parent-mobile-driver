class SchoolPointRequest {
  final List<String> studentIds;
  final double latitude;
  final double longitude;

  SchoolPointRequest({
    required this.studentIds,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_ids': studentIds,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
