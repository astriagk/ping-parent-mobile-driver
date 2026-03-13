import '../../../../../config.dart';

class WelcomeHeaderLayout extends StatelessWidget {
  const WelcomeHeaderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsUpdateProvider>(
      builder: (context, userPvr, child) {
        final name = userPvr.nameController.text;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language(context, appFonts.welcomeBack),
              style: AppCss.lexendRegular14.textColor(appTheme.hintText),
            ),
            VSpace(Insets.i4),
            Text(
              name.isNotEmpty ? name : language(context, appFonts.driver),
              style: AppCss.lexendBold24.textColor(appTheme.darkText),
            ),
            VSpace(Insets.i8),
            Text(
              language(context, appFonts.startEarningToday),
              style: AppCss.lexendRegular13.textColor(appTheme.descrTextClr),
            ),
          ],
        );
      },
    );
  }
}
