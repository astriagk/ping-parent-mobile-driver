import 'package:skolo_driver/config.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtpProvider>().startResendTimer();
    });
  }

  Future<void> _handleSignInOtpVerification(BuildContext context) async {
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

  Future<void> _handleSignUpOtpVerification(BuildContext context) async {
    final otpCtrlProvider = Provider.of<OtpProvider>(context, listen: false);
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    final phone = signUpProvider.phoneController.text.trim();
    final otp = otpCtrlProvider.pinController.text.trim();
    final result = await otpCtrlProvider.verifySignUpOtp(phone, otp);
    if (!context.mounted) return;
    if (result.success) {
      otpCtrlProvider.pinController.clear();
      signUpProvider.phoneController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
                text: result.message ?? 'OTP verified successfully')),
      );
      route.pushNamed(context, routeName.userOnboarding);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: TextWidgetCommon(
                text: result.error ?? 'OTP verification failed')),
      );
    }
  }

  Future<void> _handleResend(BuildContext context, bool isSignUp) async {
    final otpCtrl = context.read<OtpProvider>();
    final signInProvider = context.read<SignInProvider>();
    final signUpProvider = context.read<SignUpProvider>();

    final phone = isSignUp
        ? signUpProvider.phoneController.text.trim()
        : (signInProvider.currentPhone ??
            signInProvider.phoneController.text.trim());
    final countryCode =
        isSignUp ? null : signInProvider.countryCode;

    final result = await otpCtrl.resendOtp(
        phone: phone, isSignUp: isSignUp, countryCode: countryCode);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: TextWidgetCommon(
              text: result.success
                  ? (result.message ?? 'OTP resent successfully')
                  : (result.error ?? 'Failed to resend OTP'))),
    );
  }

  String _formatCountdown(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Widget _buildResendSection(
      BuildContext context, OtpProvider otpCtrl, bool isSignUp) {
    if (otpCtrl.isResendEnabled) {
      return AuthCommonWidgets().commonRichText(
          context,
          language(context, appFonts.notReceivedYet),
          language(context, appFonts.resendIt),
          onTap: otpCtrl.isResendingOtp
              ? null
              : () => _handleResend(context, isSignUp));
    }

    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: language(context, appFonts.notReceivedYet),
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.lightText)),
      TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: TextWidgetCommon(
                        text:
                            'Please wait ${_formatCountdown(otpCtrl.secondsRemaining)} before resending')),
              );
            },
          text: '  ${_formatCountdown(otpCtrl.secondsRemaining)}',
          style: AppCss.lexendMedium14
              .textColor(appColor(context).appTheme.darkText))
    ])).center();
  }

  @override
  Widget build(BuildContext context) {
    final isSignUp = ModalRoute.of(context)?.settings.arguments == true;
    return Consumer<OtpProvider>(builder: (context1, otpCtrl, child) {
      return Scaffold(
          backgroundColor: appColor(context).appTheme.bgBox,
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
                          AuthCommonWidgets().backAndLogo(context,
                              onTap: () => otpCtrl.backOnTap(context)),
                          AuthCommonWidgets().gifTitleText(
                              context,
                              language(context, appFonts.otpVerification),
                              language(context, appFonts.enterOTPSent),
                              isSignUp: isSignUp,
                              index: isSignUp ? 1 : null),
                          TextWidgetCommon(
                                  text: language(context, appFonts.otp),
                                  style: AppCss.lexendMedium14.textColor(
                                      appColor(context).appTheme.darkText))
                              .padding(bottom: Sizes.s9),
                          OTPScreenWidgets().pinPutLayout(),
                          CommonButton(
                                  text: language(context, appFonts.verify),
                                  isLoading: otpCtrl.isVerifyingOtp,
                                  onTap: otpCtrl.isVerifyingOtp
                                      ? null
                                      : () async {
                                          if (isSignUp) {
                                            await _handleSignUpOtpVerification(
                                                context);
                                          } else {
                                            await _handleSignInOtpVerification(
                                                context);
                                          }
                                        })
                              .padding(top: Sizes.s60, bottom: Sizes.s15),
                          _buildResendSection(context, otpCtrl, isSignUp),
                        ])
                        .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                        .decorated(
                            color: appColor(context).appTheme.bgBox,
                            bLRadius: Sizes.s20,
                            bRRadius: Sizes.s20),
                    AuthCommonWidgets().commonImage(context)
                  ])));
    });
  }
}
