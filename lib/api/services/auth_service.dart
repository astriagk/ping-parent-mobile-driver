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

  Future<SendOtpResponse> resendLoginOtp(
      {required String phone, String? countryCode}) async {
    try {
      final body = <String, dynamic>{'phone': phone};
      if (countryCode != null && countryCode.isNotEmpty) {
        body['countryCode'] = countryCode;
      }
      final response =
          await _apiClient.post(Endpoints.resendLoginOtp, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          return SendOtpResponse.fromJson(jsonDecode(response.body));
        } catch (_) {
          return SendOtpResponse(
              success: false,
              error:
                  'Failed to resend OTP. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      return SendOtpResponse(
          success: false, error: 'Error resending OTP: ${e.toString()}');
    }
  }

  Future<SendOtpResponse> resendRegisterOtp(
      {required String phone, String? countryCode}) async {
    try {
      final body = <String, dynamic>{'phone': phone};
      if (countryCode != null && countryCode.isNotEmpty) {
        body['countryCode'] = countryCode;
      }
      final response =
          await _apiClient.post(Endpoints.resendRegisterOtp, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SendOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        try {
          return SendOtpResponse.fromJson(jsonDecode(response.body));
        } catch (_) {
          return SendOtpResponse(
              success: false,
              error:
                  'Failed to resend OTP. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      return SendOtpResponse(
          success: false, error: 'Error resending OTP: ${e.toString()}');
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
    // Save refresh token if available
    if (response.refreshToken != null) {
      await _storage.saveRefreshToken(response.refreshToken!);
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

  /// Verify token and refresh if needed
  /// Makes request to /auth/verify-token with access token in Authorization header
  /// and refresh token in x-refresh-token header
  /// Returns new token if expired, null if still valid
  Future<VerifyTokenResponse> verifyToken() async {
    try {
      final accessToken = await _storage.getAuthToken();
      final refreshToken = await _storage.getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return VerifyTokenResponse(
          success: false,
          error: 'No tokens available',
        );
      }

      // Add refresh token to headers
      final headers = {
        'x-refresh-token': refreshToken,
      };

      final response = await _apiClient.get(
        Endpoints.verifyToken,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final verifyResponse =
            VerifyTokenResponse.fromJson(jsonDecode(response.body));

        // If new token is provided, save it
        if (verifyResponse.data?.newToken != null) {
          await _storage.saveAuthToken(verifyResponse.data!.newToken!);
        }

        // Update user ID if provided
        if (verifyResponse.data?.userId != null) {
          await _storage.saveUserId(verifyResponse.data!.userId);
        }

        return verifyResponse;
      } else {
        return VerifyTokenResponse(
          success: false,
          error: 'Failed to verify token. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return VerifyTokenResponse(
        success: false,
        error: 'Error verifying token: ${e.toString()}',
      );
    }
  }
}
