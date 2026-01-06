
import '../config.dart';

class DirectionalityRtl extends StatelessWidget {
  final Widget? child;
   const DirectionalityRtl({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer< LanguageProvider>(
      builder: (context1, languageCtrl, child1) {
        return Directionality(
            textDirection: languageCtrl.isUserRTl|| languageCtrl.getLocal() == "ar"
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!);
      },
    );
  }
}
