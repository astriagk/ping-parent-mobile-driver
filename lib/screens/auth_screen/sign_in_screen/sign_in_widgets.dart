import '../../../config.dart';

class SignInWidgets {
  //divider layout
  Widget dividerLayout(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: Sizes.s30,
          height: Sizes.s1,
          decoration: BoxDecoration(
              gradient: gradientColorChange(context,
                  firstColor: appColor(context)
                      .appTheme
                      .lightText
                      .withValues(alpha: 0.1),
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

//login with google id button
  Widget googleButton(context) {
    return Row(children: [
      Expanded(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset(svgAssets.googleLogo),
        HSpace(Sizes.s10),
        TextWidgetCommon(
                text: appFonts.withGoogleId,
                style: AppCss.lexendRegular14
                    .textColor(appColor(context).appTheme.darkText))
            .center()
      ]).height(Sizes.s46).decorated(
              allRadius: Sizes.s8, color: appColor(context).appTheme.white))
    ]).padding(bottom: Sizes.s20, top: Sizes.s9);
  }
}
