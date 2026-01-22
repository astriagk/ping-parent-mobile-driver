import 'package:taxify_driver_ui/config.dart';

class DocumentsOnboardingScreen extends StatelessWidget {
  const DocumentsOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
        builder: (context, onboardingPvr, child) {
      return Scaffold(
          body: SingleChildScrollView(
              child: Column(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // back button and taxify logo layout
          AuthCommonWidgets()
              .backAndLogo(context, onTap: () => route.pop(context)),
          // gif title and subtitle layout
          AuthCommonWidgets().gifTitleText(
              context,
              language(context, appFonts.documentVerify),
              language(context, appFonts.exploreYourLife),
              isSignUp: true,
              index: 1),
          // Documents verification layout
          const DocumentsVerifyLayout()
        ])
            .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
            .authExtension(context)
            .padding(bottom: Sizes.s20),
      ])));
    });
  }
}
