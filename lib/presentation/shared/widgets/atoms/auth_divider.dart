import 'package:skolo_driver/config.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: Sizes.s30,
          height: Sizes.s1,
          decoration: BoxDecoration(
              gradient: gradientColorChange(context,
                  firstColor:
                      appColor(context).appTheme.lightText.withValues(alpha: 0.1),
                  secColor: appColor(context).appTheme.lightText),
              borderRadius: SmoothBorderRadius(cornerRadius: 1))),
      TextWidgetCommon(
              text: appFonts.or,
              style: AppCss.lexendMedium12
                  .textColor(appColor(context).appTheme.lightText))
          .padding(horizontal: Sizes.s8, bottom: Sizes.s2),
      Container(
          width: Sizes.s30,
          height: Sizes.s1,
          decoration: BoxDecoration(
              gradient: gradientColor(context),
              borderRadius: SmoothBorderRadius(cornerRadius: 1)))
    ]);
  }
}
