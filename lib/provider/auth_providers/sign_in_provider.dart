import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/auth_service.dart';

class SignInProvider extends ChangeNotifier {
  String countryCode = "";
  String? currentPhone;
  bool isSendingOtp = false;
  String? sendOtpError;

  String? token;
  Map<String, dynamic>? user;

  final TextEditingController phoneController = TextEditingController();

  final AuthService _authService;

  SignInProvider({AuthService? authService})
      : _authService = authService ?? AuthService(ApiClient());

  void onCountryCode(String? dialCode) {
    countryCode = dialCode ?? "";
    debugPrint("dial code==>$dialCode");
    notifyListeners();
  }

  void updatePhone(String phone) {
    currentPhone = phone;
    sendOtpError = null;
    notifyListeners();
  }

  Future<SendOtpResult> sendOtp(String phone) async {
    isSendingOtp = true;
    notifyListeners();
    SendOtpResult result;
    if (phone.isEmpty) {
      result =
          SendOtpResult(success: false, error: 'Please enter a phone number');
    } else if (phone.length < 10) {
      result = SendOtpResult(
          success: false, error: 'Phone number must be at least 10 digits');
    } else {
      try {
        final response = await _authService.sendOtp(phone: phone);
        if (response.success) {
          currentPhone = phone;
          result = SendOtpResult(success: true, message: response.message);
        } else {
          result = SendOtpResult(
              success: false,
              error:
                  response.error ?? response.message ?? 'Failed to send OTP');
        }
      } catch (e) {
        result = SendOtpResult(success: false, error: 'Error: ${e.toString()}');
      }
    }
    isSendingOtp = false;
    notifyListeners();
    return result;
  }

  void clearErrors() {
    sendOtpError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}

class SendOtpResult {
  final bool success;
  final String? error;
  final String? message;
  SendOtpResult({required this.success, this.error, this.message});
}
