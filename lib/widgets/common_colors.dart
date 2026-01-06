import '../config.dart';

LinearGradient gradientColor(BuildContext context,
    {AlignmentGeometry? begin, AlignmentGeometry? end}) {
  return LinearGradient(
    colors: [
      appColor(context).appTheme.lightText,
      appColor(context).appTheme.lightText.withValues(alpha: 0.1)
    ],
  );
}

ShapeDecoration receiverBox(context) => ShapeDecoration(
    gradient: LinearGradient(colors: [
      appColor(context).appTheme.lightText.withValues(alpha: 0.1),
      appColor(context).appTheme.lightText.withValues(alpha: 0.1)
    ]),
    shape: SmoothRectangleBorder(
        borderRadius:
            SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)));

RadialGradient radialGradient(BuildContext context) {
  return RadialGradient(colors: [
    appColor(context).appTheme.primary,
    appColor(context).appTheme.primary,
  ]);
}

LinearGradient gradientColorChange(BuildContext context,
    {AlignmentGeometry? begin,
    AlignmentGeometry? end,
    Color? firstColor,
    Color? secColor}) {
  return LinearGradient(
    colors: [
      firstColor ?? appColor(context).appTheme.trans,
      secColor ?? appColor(context).appTheme.trans,
    ],
  );
}
