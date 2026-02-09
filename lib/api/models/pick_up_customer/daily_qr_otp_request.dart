class DailyQrOtpRequest {
  final String parentId;
  final String tripId;
  final String otpCode;

  DailyQrOtpRequest({
    required this.parentId,
    required this.tripId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'trip_id': tripId,
      'otp_code': otpCode,
    };
  }
}
