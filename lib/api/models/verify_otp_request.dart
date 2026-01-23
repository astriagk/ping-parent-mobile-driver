class VerifyOtpRequest {
  final String phone;
  final String otp;
  final String? role;

  VerifyOtpRequest({required this.phone, required this.otp, this.role});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'otp': otp,
        if (role != null) 'role': role,
      };
}

class VerifyOtpResponse {
  final bool success;
  final String? token;
  final Map<String, dynamic>? user;
  final String? message;
  final String? error;

  VerifyOtpResponse({
    required this.success,
    this.token,
    this.user,
    this.message,
    this.error,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      token: json['data'] != null ? json['data']['token'] : null,
      user: json['data'] != null ? json['data']['user'] : null,
      message: json['message'],
      error: json['error'],
    );
  }
}
