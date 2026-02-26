import 'package:skolo_driver/config.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  /// Handles OTP verification and result UI logic
  Future<void> _handleOtpVerification(BuildContext context) async {
    final otpCtrlProvider = Provider.of<OtpProvider>(context, listen: false);
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final phone = signInProvider.currentPhone ??
        signInProvider.phoneController.text.trim();
    final otp = otpCtrlProvider.pinController.text.trim();
    final result = await otpCtrlProvider.verifyOtp(phone, otp);
    if (!context.mounted) return;
    if (result.success) {
      otpCtrlProvider.pinController.clear();
      signInProvider.token = result.token;
      signInProvider.user = result.user;
      // Session persistence is handled in AuthService after verification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
                text: result.message ?? 'OTP verified successfully')),
      );
      route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
                text: result.error ?? 'OTP verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpProvider>(builder: (context1, otpCtrl, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) =>
                  otpCtrl.exitPopUpAlert(didPop, context),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          // back button and taxify logo layout
                          AuthCommonWidgets().backAndLogo(context,
                              onTap: () => otpCtrl.backOnTap(context)),
                          //gif title and subtitle layout
                          AuthCommonWidgets().gifTitleText(
                              context,
                              language(context, appFonts.otpVerification),
                              language(context, appFonts.enterOTPSent)),
                          TextWidgetCommon(
                                  text: language(context, appFonts.otp),
                                  style: AppCss.lexendMedium14.textColor(
                                      appColor(context).appTheme.darkText))
                              .padding(bottom: Sizes.s9),
                          // PinPut layout
                          OTPScreenWidgets().pinPutLayout(),
                          // Common button
                          CommonButton(
                                  text: language(context, appFonts.verify),
                                  isLoading: otpCtrl.isVerifyingOtp,
                                  onTap: otpCtrl.isVerifyingOtp
                                      ? null
                                      : () async {
                                          await _handleOtpVerification(context);
                                        })
                              .padding(top: Sizes.s60, bottom: Sizes.s15),
                          // Common Rich Text layout
                          AuthCommonWidgets().commonRichText(
                              context,
                              language(context, appFonts.notReceivedYet),
                              language(context, appFonts.resendIt))
                        ])
                        .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                        .decorated(
                            color: appColor(context).appTheme.bgBox,
                            bLRadius: Sizes.s20,
                            bRRadius: Sizes.s20),
                    //common car image layout
                    AuthCommonWidgets().commonImage(context)
                  ])));
    });
  }
}
