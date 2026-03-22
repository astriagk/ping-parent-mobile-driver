import 'package:skolo_driver/config.dart';

class ContainerCommon extends StatelessWidget {
  final GestureTapCallback? onTap;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorder;
  final BorderSide? borderSide;
  final String? hintText;
  final Color? color;
  final double? width, height;
  final String? imageIcon;
  final TextStyle? style;
  final IconButton? icon;
  final bool? isTitle;
  final bool? isIcon;
  final bool? isPerFixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;

  final String? title;

  const ContainerCommon(
      {super.key,
      this.onTap,
      this.borderRadius,
      this.borderSide,
      this.enabledBorder,
      this.hintText,
      this.color,
      this.width,
      this.style,
      this.icon,
      this.isIcon,
      this.imageIcon,
      this.prefixIcon,
      this.isPerFixIcon = false,
      this.suffixIcon,
      this.contentPadding,
      this.readOnly = false,
      this.title,
      this.isTitle = false,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isTitle == true ? Container() : TextWidgetCommon(text: title),
      VSpace(Sizes.s9),
      GestureDetector(
          onTap: onTap,
          child: Container(
              height: height ?? Insets.i48,
              width: width,
              padding:
                  contentPadding ?? const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                  color: color ?? Colors.white,
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  border: Border.all(
                      width: borderSide?.width ?? 2,
                      color: borderSide?.color ?? Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 20,
                        spreadRadius: 7)
                  ]),
              child: Row(children: [
                if (prefixIcon != null) prefixIcon!,
                if (isIcon == true)
                  icon ?? const Icon(Icons.search)
                else if (imageIcon != null)
                  Image.asset(imageIcon!, height: 24, width: 24),
                // const SizedBox(width: 10),
                Expanded(
                    child: Text(hintText ?? '',
                        style: style ??
                            AppCss.lexendLight12.textColor(
                                color ?? appColor(context).appTheme.hintText))),
                if (suffixIcon != null) suffixIcon!
              ])))
    ]).marginOnly(bottom: Insets.i15);
  }
}
