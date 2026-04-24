import '../../../../config.dart';
import '../../sign_in_screen/layout/country_picker.dart';

class SignUpLayout extends StatelessWidget {
  const SignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Column(children: [_buildSignUpForm(context, signUpPvr)]);
    });
  }

  Widget _buildSignUpForm(BuildContext context, SignUpProvider signUpPvr) {
    return Column(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: language(context, appFonts.mobileNumber)),
          CountryPickerLayout(controller: signUpPvr.phoneController),
        ],
      ),
      signUpPvr.sendOtpError != null
          ? TextWidgetCommon(
              text: signUpPvr.sendOtpError!,
              style: TextStyle(color: appColor(context).appTheme.alertZone),
            ).padding(bottom: Sizes.s10)
          : Container(),
      CommonButton(
        text: language(context, appFonts.signup),
        isLoading: signUpPvr.isSendingOtp,
        onTap: signUpPvr.isSendingOtp
            ? null
            : () => signUpPvr.signUpButton(context),
      ).padding(bottom: Sizes.s15),
      AuthCommonWidgets().commonRichText(
          context,
          language(context, appFonts.alreadyHaveAnAccount),
          language(context, appFonts.signIn),
          onTap: () => signUpPvr.alreadyHavingAccountSignInButton(context))
    ]);
  }
}
