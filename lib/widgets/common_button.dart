import 'package:skolo_driver/widgets/loading/loading_wave_animation.dart';

import '../config.dart';

class CommonButton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? left;
  final double? bottom;
  final double? right;
  final Color? color;
  final Color? textColor;
  final String? text;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Gradient? gradient;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final bool? isIcon;

  /// When true, shows a wave loading animation instead of text
  final bool isLoading;

  const CommonButton({
    super.key,
    this.height,
    this.width,
    this.color,
    this.text,
    this.textColor,
    this.margin,
    this.borderRadius,
    this.gradient,
    this.left,
    this.right,
    this.bottom,
    this.onTap,
    this.style,
    this.isIcon = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
              height: height ?? Sizes.s46,
              margin: margin ??
                  EdgeInsets.only(
                      left: left ?? 0, right: right ?? 0, bottom: bottom ?? 0),
              decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: Sizes.s9, cornerSmoothing: 1)),
                  color: color ?? appColor(context).appTheme.primary),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isIcon == true
                        ? SvgPicture.asset(svgAssets.import1)
                            .padding(right: Insets.i10)
                        : Container(),
                    isLoading
                        ? LoadingWaveAnimation(
                            color:
                                textColor ?? appColor(context).appTheme.white,
                            barCount: 4,
                            barWidth: 4,
                            maxHeight: 18,
                            minHeight: 6,
                          )
                        : TextWidgetCommon(
                                text: text ?? '',
                                style: style ??
                                    AppCss.lexendSemiBold15.textColor(
                                        textColor ??
                                            appColor(context).appTheme.white))
                            .center()
                  ])).inkWell(onTap: isLoading ? null : onTap))
    ]);
  }
}
