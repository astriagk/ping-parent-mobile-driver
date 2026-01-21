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

  final TextEditingController signInController = TextEditingController();
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

  Future<bool> sendOtp() async {
    final phone = phoneController.text.trim();
    print("Sending OTP to: $phone");
    // Validation
    if (phone.isEmpty) {
      sendOtpError = 'Please enter a phone number';
      notifyListeners();
      return false;
    }

    if (phone.length < 10) {
      sendOtpError = 'Phone number must be at least 10 digits';
      notifyListeners();
      return false;
    }

    isSendingOtp = true;
    sendOtpError = null;
    notifyListeners();

    try {
      // Call API to send OTP
      final response = await _authService.sendOtp(phone: phone);
      print("Send OTP response: $response");
      if (response.success) {
        currentPhone = phone;
        isSendingOtp = false;
        sendOtpError = null;
        notifyListeners();
        return true;
      } else {
        isSendingOtp = false;
        sendOtpError =
            response.error ?? response.message ?? 'Failed to send OTP';
        notifyListeners();
        return false;
      }
    } catch (e) {
      isSendingOtp = false;
      sendOtpError = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearErrors() {
    sendOtpError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    signInController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
