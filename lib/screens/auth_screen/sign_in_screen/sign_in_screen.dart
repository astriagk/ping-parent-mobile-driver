import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/auth_screen/sign_in_screen/layout/country_picker.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(builder: (context1, signInPvr, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(svgAssets.logo,
                          height: Sizes.s30, width: Sizes.s70)
                      .center()
                      .padding(top: Sizes.s60, bottom: Sizes.s15),
                  //gif title and subtitle layout
                  AuthCommonWidgets().gifTitleText(
                      context,
                      language(context, appFonts.letsYouIn),
                      language(context, appFonts.heyYouHaveBeenMissed)),
                  TextWidgetCommon(
                      text: language(context, appFonts.phoneNumber),
                      style: AppCss.lexendMedium14
                          .textColor(appColor(context).appTheme.darkText)),
                  //country picker layout
                  const CountryPickerLayout(),
                  CommonButton(
                      text: language(context, appFonts.getOTP),
                      onTap: () =>
                          route.pushNamed(context, routeName.otpScreen)),
                  //common Rich Text layout
                  AuthCommonWidgets().commonRichText(
                      context,
                      language(context, appFonts.newUser),
                      language(context, appFonts.signup), onTap: () {
                    route.pushNamed(context, routeName.signUpScreen);
                  }).padding(bottom: Sizes.s25, top: Sizes.s15)
                ]).padding(horizontal: Sizes.s20).authExtension(context),
            //common car image layout
            AuthCommonWidgets().commonImage(context)
          ]).height(MediaQuery.of(context).size.height));
    });
  }
}
