class SendOtpResponse {
  const SendOtpResponse({
    required this.success,
    this.message,
    this.error,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
        success: json['success'] ?? false,
        message: json['message'] as String?,
        error: json['error'] as String?,
      );

  final bool success;
  final String? message;
  final String? error;
}
