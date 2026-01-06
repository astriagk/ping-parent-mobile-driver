import 'package:taxify_driver_ui/config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context1, splashCtrl, child) {
      // Ensure splashCtrl is not null before using it
      return StatefulWrapper(
          onInit: () => splashCtrl.onInit(context),
          child: Scaffold(
              backgroundColor: appColor(context).appTheme.onCtrClr,
              body: Center(
                  child: Image.asset(imageAssets.taxifyLogo)
                      .marginSymmetric(horizontal: Insets.i84))));
    });
  }
}
