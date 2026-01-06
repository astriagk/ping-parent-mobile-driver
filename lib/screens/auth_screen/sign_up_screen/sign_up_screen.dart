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
                  onTap: signUpPvr.index == 0
                      ? () => signUpPvr.index0BackTap(context)
                      : signUpPvr.index == 1
                          ? () => signUpPvr.index1BackTap(context)
                          : signUpPvr.index == 2
                              ? () => signUpPvr.index2BackTap(context)
                              : signUpPvr.index == 3
                                  ? () => signUpPvr.index3BackTap(context)
                                  : () {}),
              //gif title and subtitle layout
              AuthCommonWidgets().gifTitleText(
                  isSignUp: true,
                  context,
                  signUpPvr.index == 0
                      ? language(context, appFonts.createYourAccount)
                      : signUpPvr.index == 1
                          ? language(context, appFonts.documentVerify)
                          : signUpPvr.index == 2
                              ? language(context, appFonts.vehicleRegistration)
                              : language(context, appFonts.bankDetails),
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
                              : Container(),
              //common signup button layout
              signUpPvr.index == 0
                  ? CommonButton(
                          text: language(context, appFonts.signup),
                          onTap: () => signUpPvr.signUpButton())
                      .padding(top: Sizes.s25, bottom: Sizes.s15)
                  : Container(),
              //common Rich Text layout
              signUpPvr.index == 0
                  ? AuthCommonWidgets().commonRichText(
                      context,
                      language(context, appFonts.alreadyHaveAnAccount),
                      language(context, appFonts.signIn),
                      onTap: () =>
                          signUpPvr.alreadyHavingAccountSignInButton(context))
                  : Container()
            ])
                .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                .authExtension(context)
                .padding(bottom: Sizes.s20),
            signUpPvr.index == 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(language(context, appFonts.selectYourRule),
                                style: AppCss.lexendSemiBold18
                                    .textColor(appTheme.darkText))
                            .padding(bottom: Insets.i15),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: signUpPvr.rules.length,
                            itemBuilder: (context, index) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            language(context,
                                                signUpPvr.rules[index]),
                                            style: AppCss.lexendRegular14
                                                .textColor(appTheme.textClr))),
                                    GestureDetector(
                                        onTap: () {
                                          signUpPvr.notifyListeners();
                                          signUpPvr.isChecked[index] =
                                              !signUpPvr.isChecked[index];
                                          signUpPvr.notifyListeners();
                                        },
                                        child: SvgPicture.asset(
                                            signUpPvr.isChecked[index]
                                                ? svgAssets.tickSquare
                                                : svgAssets.tickSquare1))
                                  ]).padding(bottom: Insets.i15);
                            })
                      ]).padding(horizontal: Sizes.s20)
                : Container(),
            signUpPvr.index == 0
                ? Container()
                : CommonButton(
                        text: language(context, appFonts.next),
                        onTap: signUpPvr.index == 1
                            ? () => signUpPvr.documentVerifyButton()
                            : signUpPvr.index == 2
                                ? () => signUpPvr.vehicleRegButton()
                                : signUpPvr.index == 3
                                    ? () => signUpPvr.bankDetails(context)
                                    : () {})
                    .padding(
                        top: Sizes.s10,
                        horizontal: Sizes.s20,
                        bottom: signUpPvr.index == 1
                            ? 20
                            : signUpPvr.index == 2
                                ? 20
                                : 0)
          ]))));
    });
  }
}
