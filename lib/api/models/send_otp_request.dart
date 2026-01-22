class SendOtpRequest {
  final String phone;

  SendOtpRequest({
    required this.phone,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
