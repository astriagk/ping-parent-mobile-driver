import '../../../../config.dart';

class SignUpLayout extends StatelessWidget {
  const SignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Column(children: [
        signUpPvr.isOtpSent
            ? _buildOtpVerification(context, signUpPvr)
            : _buildSignUpForm(context, signUpPvr)
      ]);
    });
  }

  Widget _buildSignUpForm(BuildContext context, SignUpProvider signUpPvr) {
    return Column(children: [
      // AuthCommonWidgets().textAndTextField(
      //     language(context, appFonts.userName),
      //     language(context, appFonts.enterYourName),
      //     context),
      //title text and text filed layout
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: language(context, appFonts.mobileNumber)),
          VSpace(Sizes.s9),
          TextFieldCommon(
            controller: signUpPvr.phoneController,
            hintText: language(context, appFonts.enterYourNumber),
          )
        ],
      ).padding(vertical: Sizes.s15),
      //title text and text filed layout
      // AuthCommonWidgets().textAndTextField(language(context, appFonts.email),
      //     language(context, appFonts.enterYourEmailId), context),
      // //title text and text filed layout
      // AuthCommonWidgets()
      //     .textAndTextField(language(context, appFonts.countryCode),
      //         language(context, appFonts.enterCountryCode), context)
      //     .padding(vertical: Sizes.s15),
      // //title text and text filed layout
      // AuthCommonWidgets().textAndTextField(
      //     language(context, appFonts.referralID),
      //     language(context, appFonts.enterReferralID),
      //     context),
      VSpace(Sizes.s25),
      signUpPvr.sendOtpError != null
          ? TextWidgetCommon(
              text: signUpPvr.sendOtpError!,
              style: TextStyle(color: appColor(context).appTheme.alertZone),
            ).padding(bottom: Sizes.s10)
          : Container(),
      signUpPvr.isSendingOtp
          ? const Center(child: CircularProgressIndicator())
              .padding(vertical: Sizes.s15)
          : CommonButton(
              text: language(context, appFonts.signup),
              onTap: () => signUpPvr.signUpButton(),
            ).padding(bottom: Sizes.s15),
      AuthCommonWidgets().commonRichText(
          context,
          language(context, appFonts.alreadyHaveAnAccount),
          language(context, appFonts.signIn),
          onTap: () => signUpPvr.alreadyHavingAccountSignInButton(context))
    ]);
  }

  Widget _buildOtpVerification(BuildContext context, SignUpProvider signUpPvr) {
    return Column(children: [
      TextWidgetCommon(
              text: language(context, 'Enter OTP sent to'),
              style: AppCss.lexendRegular14.textColor(appTheme.textClr))
          .padding(bottom: Sizes.s15),
      TextWidgetCommon(
              text: signUpPvr.phoneController.text,
              style: AppCss.lexendSemiBold14.textColor(appTheme.darkText))
          .padding(bottom: Sizes.s20),
      // OTP Input
      Pinput(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              controller: signUpPvr.otpController,
              length: 6,
              isCursorAnimationEnabled: false,
              onClipboardFound: (value) =>
                  signUpPvr.otpController.setText(value),
              defaultPinTheme: PinTheme(
                  height: Sizes.s50,
                  width: Sizes.s50,
                  decoration: BoxDecoration(
                      color: appColor(context).appTheme.white,
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: Sizes.s8, cornerSmoothing: 2)),
                  textStyle: AppCss.lexendRegular16
                      .textColor(appColor(context).appTheme.darkText)))
          .decorated(boxShadow: [
        BoxShadow(
            color: appColor(context).appTheme.primary.withValues(alpha: 0.03),
            blurRadius: 20,
            spreadRadius: 7)
      ]).padding(vertical: Sizes.s25),
      signUpPvr.verifyOtpError != null
          ? TextWidgetCommon(
              text: signUpPvr.verifyOtpError!,
              style: TextStyle(color: appColor(context).appTheme.alertZone),
            ).padding(bottom: Sizes.s10)
          : Container(),
      signUpPvr.isVerifyingOtp
          ? const Center(child: CircularProgressIndicator())
              .padding(vertical: Sizes.s15)
          : CommonButton(
              text: language(context, appFonts.verify),
              onTap: () async {
                final success = await signUpPvr.verifySignUpOtp();
                if (success && context.mounted) {
                  route.pushNamed(context, routeName.userOnboarding);
                }
              },
            ).padding(bottom: Sizes.s15),
      AuthCommonWidgets().commonRichText(
          context, '', language(context, 'Change Number'), onTap: () {
        signUpPvr.isOtpSent = false;
        signUpPvr.otpController.clear();
        signUpPvr.notifyListeners();
      }),
    ]);
  }
}
