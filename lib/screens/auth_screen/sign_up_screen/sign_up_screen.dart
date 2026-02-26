import 'package:skolo_driver/config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
              child: Column(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // back button and taxify logo layout
              AuthCommonWidgets().backAndLogo(context,
                  onTap: () => signUpPvr.handleBackTap(context)),
              //gif title and subtitle layout
              AuthCommonWidgets().gifTitleText(
                  context,
                  signUpPvr.getTitleText(context),
                  language(context, appFonts.exploreYourLife),
                  isSignUp: true,
                  index: 0),
              //signup layout only
              const SignUpLayout()
            ])
                .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                .authExtension(context)
                .padding(bottom: Sizes.s20)
          ])));
    });
  }
}
