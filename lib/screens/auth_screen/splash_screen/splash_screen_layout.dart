import 'dart:developer';

import 'package:skolo_driver/config.dart';

class SplashScreenLayout extends StatefulWidget {
  const SplashScreenLayout({super.key});

  @override
  State<SplashScreenLayout> createState() => _SplashScreenLayoutState();
}

class _SplashScreenLayoutState extends State<SplashScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF1F1F1F),
        body: Center(
            child: Image.asset(imageAssets.taxifyLogo)
                .marginSymmetric(horizontal: Insets.i84)));
  }

  @override
  void didChangeDependencies() {
    log("null");
    super.didChangeDependencies();
    Future.delayed(DurationClass.s1).then((value) {
      if (mounted) {
        route.pushNamed(context, AppRoute.signIn.path);
      }
    });
  }
}
