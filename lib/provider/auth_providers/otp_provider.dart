import 'dart:async';
import '../../api/services/auth_service.dart';
import '../../api/api_client.dart';
import 'package:skolo_driver/config.dart';

class OtpProvider extends ChangeNotifier {
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isVerifyingOtp = false;
  String? verifyOtpError;
  bool isResendingOtp = false;
  int secondsRemaining = 120;
  bool isResendEnabled = false;
  Timer? _resendTimer;
  final AuthService _authService = AuthService(ApiClient());

  void startResendTimer() {
    _resendTimer?.cancel();
    secondsRemaining = 120;
    isResendEnabled = false;
    notifyListeners();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        isResendEnabled = true;
        _resendTimer?.cancel();
        notifyListeners();
      }
    });
  }

  Future<ResendOtpResult> resendOtp({
    required String phone,
    required bool isSignUp,
    String? countryCode,
  }) async {
    isResendingOtp = true;
    notifyListeners();
    try {
      final response = isSignUp
          ? await _authService.resendRegisterOtp(
              phone: phone, countryCode: countryCode)
          : await _authService.resendLoginOtp(
              phone: phone, countryCode: countryCode);
      isResendingOtp = false;
      if (response.success) {
        startResendTimer();
      }
      notifyListeners();
      return ResendOtpResult(
          success: response.success,
          message: response.message,
          error: response.error);
    } catch (e) {
      isResendingOtp = false;
      notifyListeners();
      return ResendOtpResult(success: false, error: 'Error resending OTP');
    }
  }

  backOnTap(context) {
    pinController.text = "";
    _resendTimer?.cancel();
    route.pop(context);
    notifyListeners();
  }

  Future<OtpVerifyResult> verifyOtp(String phone, String otp) async {
    if (phone.isEmpty || otp.isEmpty) {
      return OtpVerifyResult(
          success: false, error: 'Phone and OTP are required');
    }
    isVerifyingOtp = true;
    verifyOtpError = null;
    notifyListeners();
    try {
      final response = await _authService.verifyOtp(phone: phone, otp: otp);
      isVerifyingOtp = false;
      verifyOtpError = null;
      notifyListeners();
      if (response.success) {
        return OtpVerifyResult(
          success: true,
          message: response.message,
          token: response.token,
          user: response.user,
        );
      } else {
        return OtpVerifyResult(
          success: false,
          error:
              response.error ?? response.message ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      isVerifyingOtp = false;
      verifyOtpError = 'Error verifying OTP';
      notifyListeners();
      return OtpVerifyResult(success: false, error: 'Error verifying OTP');
    }
  }

  Future<OtpVerifyResult> verifySignUpOtp(String phone, String otp) async {
    if (phone.isEmpty || otp.isEmpty) {
      return OtpVerifyResult(
          success: false, error: 'Phone and OTP are required');
    }
    isVerifyingOtp = true;
    verifyOtpError = null;
    notifyListeners();
    try {
      final response =
          await _authService.registerVerifyOtp(phone: phone, otp: otp);
      isVerifyingOtp = false;
      verifyOtpError = null;
      notifyListeners();
      if (response.success) {
        return OtpVerifyResult(
          success: true,
          message: response.message,
          token: response.token,
          user: response.user,
        );
      } else {
        return OtpVerifyResult(
          success: false,
          error:
              response.error ?? response.message ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      isVerifyingOtp = false;
      verifyOtpError = 'Error verifying OTP';
      notifyListeners();
      return OtpVerifyResult(success: false, error: 'Error verifying OTP');
    }
  }

  void clearErrors() {
    verifyOtpError = null;
    isVerifyingOtp = false;
    notifyListeners();
  }

  exitPopUpAlert(didPop, context) {
    if (didPop) return;
    pinController.text = "";
    _resendTimer?.cancel();
    route.pop(context);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class ResendOtpResult {
  final bool success;
  final String? error;
  final String? message;
  ResendOtpResult({required this.success, this.error, this.message});
}

class OtpVerifyResult {
  final bool success;
  final String? error;
  final String? message;
  final String? token;
  final dynamic user;
  OtpVerifyResult({
    required this.success,
    this.error,
    this.message,
    this.token,
    this.user,
  });
}
