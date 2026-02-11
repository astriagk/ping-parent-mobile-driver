class PickupPointRequest {
  final List<String> studentIds;
  final List<String> absentStudentIds;
  final String? otpCode;
  final double latitude;
  final double longitude;

  PickupPointRequest({
    required this.studentIds,
    required this.absentStudentIds,
    this.otpCode,
    required this.latitude,
    required this.longitude,
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

    // Only include absent_student_ids if not empty
    if (absentStudentIds.isNotEmpty) {
      json['absent_student_ids'] = absentStudentIds;
    }

    // Only include otp_code if there are present students
    if (otpCode != null && studentIds.isNotEmpty) {
      json['otp_code'] = otpCode;
    }

    return json;
  }
}
