import '../config.dart';

class TextWidgetCommon extends StatelessWidget {
  const TextWidgetCommon(
      {super.key,
      this.text,
      this.textAlign,
      this.style,
      this.color,
      this.overflow,
      this.fontSize,
      this.fontHeight,
      this.textDecoration,
      this.fontWeight});

  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final Color? color;
  final TextOverflow? overflow;
  final double? fontSize;
  final double? fontHeight;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
        overflow: overflow,
        language(context, text ?? ""),
        textAlign: textAlign ?? TextAlign.start,
        style: style ??
            // TextStyle(decoration:textDecoration??TextDecoration.none,
            //     height: fontHeight??1.2,
            //     color: color ?? appColor(context).appTheme.darkText,
            //     fontSize: fontSize??Sizes.s14,
            //     fontWeight: fontWeight??FontWeight.w400,
            //     fontFamily: GoogleFonts.lexend().fontFamily)
            AppCss.lexendMedium14
                .textColor(color ?? appColor(context).appTheme.darkText)
                .textHeight(1.2)
                .textDecoration(TextDecoration.none));
  }
}
