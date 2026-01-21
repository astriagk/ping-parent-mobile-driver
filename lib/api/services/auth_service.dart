import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageService _storage = StorageService();

  AuthService(this._apiClient);

  Future<SendOtpResponse> sendOtp({required String phone}) async {
    try {
      // Save phone temporarily for OTP verification
      await _storage.saveUserPhone(phone);

      final request = SendOtpRequest(phone: phone);
      final response = await _apiClient.post(
        Endpoints.sendOtp,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        return SendOtpResponse(
          success: false,
          error: 'Failed to send OTP. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Error sending OTP: $e',
      );
    }
  }

  /// Logout - Clear all authentication data
  Future<void> logout() async {
    await _storage.logout();
  }

  /// Check if user has valid session
  Future<bool> hasValidSession() async {
    return await _storage.hasValidSession();
  }
}
