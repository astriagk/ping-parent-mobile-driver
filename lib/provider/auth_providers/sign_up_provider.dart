import 'dart:io';
import '../../api/api_client.dart';
import '../../api/services/auth_service.dart';
import '../../config.dart';

class SignUpProvider extends ChangeNotifier {
  // OTP state
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  String? sendOtpError;
  String? verifyOtpError;
  bool isOtpSent = false;

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

    /* PermissionStatus status = await Permission.photos.request();
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }
    log("permission hello $status");
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 800,
          maxWidth: 800);

      if (pickedFile != null) {
        notifyListeners();
        image = File(pickedFile.path);
        notifyListeners();
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied. Cannot pick image.',
              style: AppCss.lexendRegular16.textColor(appTheme.darkText))));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }*/
  }

  handleBackTap(context) {
    route.pop(context);
    notifyListeners();
  }

  String getTitleText(BuildContext context) {
    return language(context, appFonts.createYourAccount);
  }

  /*vehicleChooseOnTap() {
    selectedIndex = index;
    notifyListeners();
  }*/

  signUpButton() {
    registerSendOtp();
  }

  Future<void> registerSendOtp() async {
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
        // Show OTP input instead of moving to next index
        isOtpSent = true;
        sendOtpError = null;
      } else {
        sendOtpError =
            response.error ?? response.message ?? 'Failed to send OTP';
      }
    } catch (e) {
      sendOtpError = 'Error: [${e.toString()}';
    }
    isSendingOtp = false;
    notifyListeners();
  }

  Future<bool> verifySignUpOtp() async {
    isVerifyingOtp = true;
    verifyOtpError = null;
    notifyListeners();

    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      verifyOtpError = 'Please enter a valid 6-digit OTP';
      isVerifyingOtp = false;
      notifyListeners();
      return false;
    }

    try {
      final response =
          await _authService.registerVerifyOtp(phone: phone, otp: otp);
      if (response.success) {
        otpController.clear();
        phoneController.clear();
        isOtpSent = false;
        verifyOtpError = null;
        isVerifyingOtp = false;
        notifyListeners();
        return true;
      } else {
        verifyOtpError =
            response.error ?? response.message ?? 'Failed to verify OTP';
      }
    } catch (e) {
      verifyOtpError = 'Error: ${e.toString()}';
    }
    isVerifyingOtp = false;
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  alreadyHavingAccountSignInButton(context) {
    route.pushNamed(context, routeName.signInScreen);
  }
}
