import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_request.dart';
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
          error: 'Failed to send OTP. Status',
        );
      }
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Error sending OTP',
      );
    }
  }

  Future<VerifyOtpResponse> verifyOtp(
      {required String phone, required String otp}) async {
    try {
      final request = VerifyOtpRequest(phone: phone, otp: otp);
      final response = await _apiClient.post(
        Endpoints.verifyOtp,
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerifyOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        return VerifyOtpResponse(
          success: false,
          error: 'Failed to verify OTP.',
        );
      }
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        error: 'Error verifying OTP',
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
