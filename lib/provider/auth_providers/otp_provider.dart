import '../../api/services/auth_service.dart';
import '../../api/api_client.dart';
import 'package:skolo_driver/config.dart';

class OtpProvider extends ChangeNotifier {
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isVerifyingOtp = false;
  String? verifyOtpError;
  final AuthService _authService = AuthService(ApiClient());

  backOnTap(context) {
    pinController.text = "";
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
    route.pop(context);
  }
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
