import '../../../../config.dart';

class SignUpLayout extends StatelessWidget {
  const SignUpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AuthCommonWidgets().textAndTextField(language(context, appFonts.userName),
          language(context, appFonts.enterYourName), context),
      //title text and text filed layout
      AuthCommonWidgets()
          .textAndTextField(language(context, appFonts.mobileNumber),
              language(context, appFonts.enterYourNumber), context)
          .padding(vertical: Sizes.s15),
      //title text and text filed layout
      AuthCommonWidgets().textAndTextField(language(context, appFonts.email),
          language(context, appFonts.enterYourEmailId), context),
      //title text and text filed layout
      AuthCommonWidgets()
          .textAndTextField(language(context, appFonts.countryCode),
              language(context, appFonts.enterCountryCode), context)
          .padding(vertical: Sizes.s15),
      //title text and text filed layout
      AuthCommonWidgets().textAndTextField(
          language(context, appFonts.referralID),
          language(context, appFonts.enterReferralID),
          context)
    ]);
  }
}
