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
              'Welcome back,',
              style: AppCss.lexendRegular14.textColor(appTheme.hintText),
            ),
            VSpace(Insets.i4),
            Text(
              name.isNotEmpty ? name : 'Driver',
              style: AppCss.lexendBold24.textColor(appTheme.darkText),
            ),
            VSpace(Insets.i8),
            Text(
              'Start earning today — accept rides nearby and make every trip count.',
              style: AppCss.lexendRegular13.textColor(appTheme.descrTextClr),
            ),
          ],
        );
      },
    );
  }
}
