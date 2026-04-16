class VerifyTokenResponse {
  final bool success;
  final VerifyTokenData? data;
  final String? message;
  final String? error;

  VerifyTokenResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTokenResponse(
      success: json['success'] ?? false,
      data:
          json['data'] != null ? VerifyTokenData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class VerifyTokenData {
  final String userId;
  final String role;
  final bool tokenValid;
  final String? newToken;

  VerifyTokenData({
    required this.userId,
    required this.role,
    required this.tokenValid,
    this.newToken,
  });

  factory VerifyTokenData.fromJson(Map<String, dynamic> json) {
    return VerifyTokenData(
      userId: json['userId'] ?? '',
      role: json['role'] ?? '',
      tokenValid: json['tokenValid'] ?? false,
      newToken: json['newToken'],
    );
  }
}
