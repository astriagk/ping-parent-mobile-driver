import 'dart:io';
import '../../api/api_client.dart';
import '../../api/services/auth_service.dart';
import '../../config.dart';

class SignUpProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  bool isSendingOtp = false;
  String? sendOtpError;

  final AuthService _authService = AuthService(ApiClient());

  SignUpProvider() {
    phoneController.addListener(() {
      if (sendOtpError != null) {
        sendOtpError = null;
        notifyListeners();
      }
    });
  }

  File? image;

  Future<void> pickImage(
    context,
    /* {required ImageSource source}*/
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language(context, appFonts.upload),
                              style: AppCss.lexendMedium16
                                  .textColor(appTheme.primary)),
                          CommonIconButton(
                              icon: svgAssets.close,
                              onTap: () => route.pop(context))
                        ]),
                    SizedBox(height: Insets.i20),
                    ListTile(
                        leading:
                            Icon(Icons.photo_library, color: appTheme.primary),
                        title: Text(
                            language(context, appFonts.selectFromGallery),
                            style: AppCss.lexendMedium16
                                .textColor(appTheme.primary)),
                        onTap: () => route.pop(context)),
                    ListTile(
                        leading:
                            Icon(Icons.camera_alt, color: appTheme.primary),
                        title: Text(language(context, appFonts.openCamera),
                            style: AppCss.lexendMedium16
                                .textColor(appTheme.primary)),
                        onTap: () => route.pop(context))
                  ])));
        });
  }

  handleBackTap(context) {
    route.pop(context);
    notifyListeners();
  }

  String getTitleText(BuildContext context) {
    return language(context, appFonts.createYourAccount);
  }

  signUpButton(BuildContext context) {
    registerSendOtp(context);
  }

  Future<void> registerSendOtp(BuildContext context) async {
    isSendingOtp = true;
    sendOtpError = null;
    notifyListeners();
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      sendOtpError = 'Please enter a phone number';
      isSendingOtp = false;
      notifyListeners();
      return;
    } else if (phone.length < 10) {
      sendOtpError = 'Phone number must be at least 10 digits';
      isSendingOtp = false;
      notifyListeners();
      return;
    }
    try {
      final response = await _authService.registerSendOtp(phone: phone);
      if (response.success) {
        sendOtpError = null;
        isSendingOtp = false;
        notifyListeners();
        if (context.mounted) {
          route.pushNamed(context, AppRoute.otp.path, arg: true);
        }
        return;
      } else {
        sendOtpError =
            response.error ?? response.message ?? 'Failed to send OTP';
      }
    } catch (e) {
      sendOtpError = 'Error: ${e.toString()}';
    }
    isSendingOtp = false;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  alreadyHavingAccountSignInButton(context) {
    route.pushNamed(context, AppRoute.signIn.path);
  }
}
