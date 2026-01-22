import 'package:taxify_driver_ui/config.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signUpPvr, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              Duration(microseconds: 150), () => signUpPvr.onInit()),
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // back button and taxify logo layout
              AuthCommonWidgets().backAndLogo(context,
                  onTap: () => signUpPvr.handleBackTap(context)),
              //gif title and subtitle layout
              AuthCommonWidgets().gifTitleText(
                  isSignUp: true,
                  context,
                  signUpPvr.getTitleText(context),
                  language(context, appFonts.exploreYourLife),
                  index: signUpPvr.index),
              //title text and text filed layout
              signUpPvr.index == 0
                  ? const SignUpLayout()
                  : signUpPvr.index == 1
                      ? const DocumentsVerifyLayout()
                      : signUpPvr.index == 2
                          ? const VehicleRegistrationsLayout()
                          : signUpPvr.index == 3
                              ? const BankDetailsLayout()
                              : Container()
            ])
                .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                .authExtension(context)
                .padding(bottom: Sizes.s20),
          ]))));
    });
  }
}
