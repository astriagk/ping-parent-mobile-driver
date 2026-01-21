import '../../api/services/auth_service.dart';
import '../../api/api_client.dart';
import 'package:taxify_driver_ui/config.dart';

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

  Future<void> verifyOtp(context) async {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final otp = pinController.text.trim();
    final phone = signInProvider.currentPhone ??
        signInProvider.phoneController.text.trim();
    if (phone.isEmpty || otp.isEmpty) {
      verifyOtpError = 'Phone and OTP are required';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidgetCommon(text: verifyOtpError)),
      );
      return;
    }
    isVerifyingOtp = true;
    verifyOtpError = null;
    notifyListeners();
    try {
      final response = await _authService.verifyOtp(phone: phone, otp: otp);
      if (response.success) {
        signInProvider.token = response.token;
        signInProvider.user = response.user;
        isVerifyingOtp = false;
        verifyOtpError = null;
        notifyListeners();
        route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
      } else {
        isVerifyingOtp = false;
        verifyOtpError =
            response.error ?? response.message ?? 'OTP verification failed';
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidgetCommon(text: verifyOtpError)),
        );
      }
    } catch (e) {
      isVerifyingOtp = false;
      verifyOtpError = 'Error verifying OTP';
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidgetCommon(text: verifyOtpError)),
      );
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
