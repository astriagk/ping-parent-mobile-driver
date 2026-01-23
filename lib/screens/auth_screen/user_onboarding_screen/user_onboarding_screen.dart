import 'package:taxify_driver_ui/config.dart';

class UserOnboardingScreen extends StatelessWidget {
  const UserOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, onboardingPvr, child) {
        return StatefulWrapper(
          onInit: () => onboardingPvr.onInit(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // back button and taxify logo layout
                      AuthCommonWidgets().backAndLogo(context,
                          onTap: () => route.pop(context)),
                      // gif title and subtitle layout
                      AuthCommonWidgets().gifTitleText(
                        context,
                        language(context, appFonts.userRegistration),
                        language(context, appFonts.exploreYourLife),
                        isSignUp: true,
                        index: 1,
                      ),
                      // User registration layout
                      const UserRegistrationsLayout(),
                    ],
                  )
                      .padding(horizontal: Sizes.s20, bottom: Sizes.s20)
                      .authExtension(context)
                      .padding(bottom: Sizes.s20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
