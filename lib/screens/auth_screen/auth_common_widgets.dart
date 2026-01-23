import 'package:avatar_glow/avatar_glow.dart';

import '../../config.dart';

class AuthCommonWidgets {
  //title text and text field layout
  Widget textAndTextField(String? title, String? hintText, context,
      {titleColor,
      fieldBgColor,
      prefixIcon,
      style,
      TextInputType? keyboardType,
      isPerFixIcon,
      inputFormat,
      TextEditingController? controller}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidgetCommon(text: title, color: titleColor),
          VSpace(Sizes.s9),
          TextFieldCommon(
              controller: controller,
              inputFormat: inputFormat,
              keyboardType: keyboardType,
              style: style,
              prefixIcon: prefixIcon,
              hintText: hintText,
              color: fieldBgColor ?? appColor(context).appTheme.screenBg)
        ]);
  }

// back button and texify logo layout
  Widget backAndLogo(context, {GestureTapCallback? onTap}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      //common back button
      CommonIconButton(
              onTap: onTap ?? () => route.pop(context), icon: svgAssets.back)
          .marginOnly(right: MediaQuery.of(context).size.width * 0.2),
      SvgPicture.asset(svgAssets.logo, height: Sizes.s30, width: Sizes.s70),
      Container()
    ]).padding(top: Sizes.s60, bottom: Sizes.s5);
  }

//gif title and subtitle layout
  Widget gifTitleText(context, String? title, String? text,
      {bool isSignUp = false, index}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isSignUp == true
          ? commonCompletedDivider(index: index)
          : Image.asset(gifAssets.successGif,
                  height: Sizes.s10, width: Sizes.s50, fit: BoxFit.fill)
              .marginOnly(top: Sizes.s30, bottom: Sizes.s6),
      TextWidgetCommon(
          text: title,
          style: AppCss.lexendMedium22
              .textColor(appColor(context).appTheme.darkText)),
      TextWidgetCommon(
              text: text,
              style: AppCss.lexendRegular13
                  .textColor(appColor(context).appTheme.lightText))
          .padding(top: Sizes.s8, bottom: Sizes.s30),
    ]);
  }

  Widget commonCompletedDivider({int index = 0}) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: Container(
              height: Insets.i4,
              decoration: BoxDecoration(
                  color: index >= 0 ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r6)))),
      SizedBox(width: Insets.i6),
      Expanded(
          child: Container(
              height: Insets.i4,
              decoration: BoxDecoration(
                  color: index >= 1 ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r6)))),
      SizedBox(width: Insets.i6),
      Expanded(
          child: Container(
              height: Insets.i4,
              decoration: BoxDecoration(
                  color: index >= 2 ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r6)))),
      SizedBox(width: Insets.i6),
      Expanded(
          child: Container(
              height: Insets.i4,
              decoration: BoxDecoration(
                  color: index >= 3 ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r6))))
    ]).marginOnly(top: Sizes.s20, bottom: Sizes.s24);
  }

//common Rich Text layout
  Widget commonRichText(context, String? text, String? darkText,
      {Function()? onTap}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: text,
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.lightText)),
      TextSpan(
          recognizer: TapGestureRecognizer()..onTap = onTap,
          text: " $darkText",
          style: AppCss.lexendRegular12
              .textColor(appColor(context).appTheme.darkText))
    ])).center();
  }

  bool animate = true;

//common car image layout
  Widget commonImage(context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(children: [
          Image.asset(imageAssets.authLayoutBg1),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.104,
              right: MediaQuery.of(context).size.height * 0.25,
              child: AvatarGlow(
                  curve: Curves.easeInOutCirc,
                  glowColor: Color(0xff8F8F8F),
                  endRadius: 90.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  animate: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Image.asset(imageAssets.taxi,
                      height: Insets.i50, fit: BoxFit.fill)))
        ]));
  }
}
