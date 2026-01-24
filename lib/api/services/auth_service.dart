import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/index.dart';
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
        try {
          final errorResponse =
              SendOtpResponse.fromJson(jsonDecode(response.body));
          return errorResponse;
        } catch (_) {
          return SendOtpResponse(
            success: false,
            error: 'Failed to send OTP. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Error sending OTP: ${e.toString()}',
      );
    }
  }

  Future<SendOtpResponse> registerSendOtp({required String phone}) async {
    try {
      // Save phone temporarily for OTP verification
      await _storage.saveUserPhone(phone);

      final request = SendOtpRequest(phone: phone);
      final response = await _apiClient.post(
        Endpoints.registerSendOtp,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          final errorResponse =
              SendOtpResponse.fromJson(jsonDecode(response.body));
          return errorResponse;
        } catch (_) {
          return SendOtpResponse(
            success: false,
            error: 'Failed to send OTP. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Error sending OTP: ${e.toString()}',
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
        final verifyResponse =
            VerifyOtpResponse.fromJson(jsonDecode(response.body));
        await saveUserSession(verifyResponse, phone);
        return verifyResponse;
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

  Future<VerifyOtpResponse> registerVerifyOtp(
      {required String phone, required String otp}) async {
    try {
      final request = VerifyOtpRequest(phone: phone, otp: otp, role: 'driver');
      final response = await _apiClient.post(
        Endpoints.registerVerifyOtp,
        body: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final verifyResponse =
            VerifyOtpResponse.fromJson(jsonDecode(response.body));
        await saveUserSession(verifyResponse, phone);
        return verifyResponse;
      } else {
        try {
          final errorResponse =
              VerifyOtpResponse.fromJson(jsonDecode(response.body));
          return errorResponse;
        } catch (_) {
          return VerifyOtpResponse(
            success: false,
            error: 'Failed to verify OTP. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        error: 'Error verifying OTP: ${e.toString()}',
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

  /// Save user session after successful OTP verification
  Future<void> saveUserSession(VerifyOtpResponse response, String phone) async {
    if (response.token != null) {
      await _storage.saveAuthToken(response.token!);
      await _storage.saveUserPhone(phone);
      await _storage.saveLoginStatus(true);
    }
    // Save user data if available
    if (response.user != null) {
      final userData = response.user!;
      if (userData['id'] != null) {
        await _storage.saveUserId(userData['id'].toString());
      }
      if (userData['name'] != null) {
        await _storage.saveUserName(userData['name'].toString());
      }
      if (userData['email'] != null) {
        await _storage.saveUserEmail(userData['email'].toString());
      }
    }
  }
}
