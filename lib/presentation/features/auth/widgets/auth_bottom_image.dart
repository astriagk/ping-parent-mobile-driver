import 'package:avatar_glow/avatar_glow.dart';
import 'package:skolo_driver/config.dart';

/// Molecule — Auth screen bottom illustration: background image + glowing taxi.
class AuthBottomImage extends StatelessWidget {
  const AuthBottomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(children: [
        Image.asset(imageAssets.authLayoutBg1),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.104,
            right: MediaQuery.of(context).size.height * 0.25,
            child: AvatarGlow(
                curve: Curves.easeInOutCirc,
                glowColor: appColor(context).appTheme.descrTextClr,
                endRadius: 90.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                animate: true,
                showTwoGlows: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: Image.asset(imageAssets.taxi,
                    height: Insets.i50, fit: BoxFit.fill)))
      ]),
    );
  }
}
