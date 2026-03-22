import 'package:skolo_driver/config.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(children: [
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(iconAsset),
          HSpace(Sizes.s10),
          TextWidgetCommon(
                  text: label,
                  style: AppCss.lexendRegular14
                      .textColor(appColor(context).appTheme.darkText))
              .center()
        ]).height(Sizes.s46).decorated(
                allRadius: Sizes.s8, color: appColor(context).appTheme.white))
      ]).padding(bottom: Sizes.s20, top: Sizes.s9),
    );
  }
}
