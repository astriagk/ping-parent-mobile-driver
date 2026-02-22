class DailyQrOtpResponse {
  final bool success;
  final DailyQrOtpData? data;
  final String? message;
  final String? error;

  DailyQrOtpResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory DailyQrOtpResponse.fromJson(Map<String, dynamic> json) {
    return DailyQrOtpResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? DailyQrOtpData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class DailyQrOtpData {
  final String id;
  final String parentId;
  final List<String> studentIds;
  final String tripId;
  final String? qrCode;
  final String otpCode;
  final String tripType;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isUsed;
  final DateTime createdAt;

  DailyQrOtpData({
    required this.id,
    required this.parentId,
    required this.studentIds,
    required this.tripId,
    this.qrCode,
    required this.otpCode,
    required this.tripType,
    required this.validFrom,
    required this.validUntil,
    required this.isUsed,
    required this.createdAt,
  });

  factory DailyQrOtpData.fromJson(Map<String, dynamic> json) {
    return DailyQrOtpData(
      id: json['_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      studentIds: List<String>.from(json['student_ids'] ?? []),
      tripId: json['trip_id'] ?? '',
      qrCode: json['qr_code'],
      otpCode: json['otp_code'] ?? '',
      tripType: json['trip_type'] ?? '',
      validFrom: DateTime.parse(
          json['valid_from'] ?? DateTime.now().toIso8601String()),
      validUntil: DateTime.parse(
          json['valid_until'] ?? DateTime.now().toIso8601String()),
      isUsed: json['is_used'] ?? false,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
