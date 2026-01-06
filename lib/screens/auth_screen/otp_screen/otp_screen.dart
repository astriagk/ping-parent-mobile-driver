import 'package:taxify_driver_ui/config.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                                  onTap: () => otpCtrl.verifyOtp(context))
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
