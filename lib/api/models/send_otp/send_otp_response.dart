class SendOtpResponse {
  final bool success;
  final String? message;
  final String? error;

  SendOtpResponse({
    required this.success,
    this.message,
    this.error,
  });

  /// Factory constructor to parse JSON response
  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
    };
  }
}
