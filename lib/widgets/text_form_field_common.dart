import 'package:flutter/services.dart';

import '../config.dart';

class TextFieldCommon extends StatelessWidget {
  final GestureTapCallback? onTap;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorder;
  final BorderSide? borderSide;
  final String? hintText;
  final Color? color;
  final Color? textColor;
  final double? width;
  final int? minLines;
  final String? imageIcon;
  final String? preImageIcon;
  final TextEditingController? controller;
  final TextStyle? style;
  final IconButton? icon;
  final bool? isIcon;
  final bool? isPerFixIcon;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;
  final FormFieldSetter? onSaved;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormat;

  const TextFieldCommon(
      {super.key,
      this.onTap,
      this.borderRadius,
      this.borderSide,
      this.enabledBorder,
      this.hintText,
      this.color,
      this.textColor,
      this.width,
      this.controller,
      this.style,
      this.icon,
      this.isIcon,
      this.validator,
      this.keyboardType,
      this.maxLength,
      this.obscureText = false,
      this.readOnly = false,
      this.onSaved,
      this.onChanged,
      this.imageIcon,
      this.prefixIcon,
      this.prefix,
      this.isPerFixIcon = false,
      this.suffixIcon,
      this.focusNode,
      this.contentPadding,
      this.suffix,
      this.minLines,
      this.maxLines,
      this.preImageIcon,
      this.inputFormat,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            inputFormatters: inputFormat,
            onChanged: onChanged,
            onSaved: onSaved,
            onTap: onTap,
            readOnly: readOnly,
            cursorOpacityAnimates: false,
            focusNode: focusNode,
            style: AppCss.lexendRegular14,
            scrollPadding: EdgeInsets.zero,
            validator: validator,
            keyboardType: keyboardType,
            maxLength: maxLength,
            controller: controller,
            obscureText: obscureText,
            minLines: minLines ?? 1,
            maxLines: maxLines ?? 1,
            textInputAction: TextInputAction.next,
            decoration: decoration ??
                InputDecoration(
                    isDense: true,
                    filled: true,
                    contentPadding: contentPadding ??
                        EdgeInsets.symmetric(
                            horizontal: Sizes.s15, vertical: Sizes.s20),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: borderRadius ??
                            SmoothBorderRadius(
                                cornerRadius: Sizes.s8, cornerSmoothing: 2),
                        borderSide: borderSide ??
                            BorderSide(
                                width: 2,
                                color:
                                    color ?? appColor(context).appTheme.trans)),
                    fillColor: color ?? appColor(context).appTheme.screenBg,
                    border: OutlineInputBorder(
                        borderRadius: borderRadius ??
                            SmoothBorderRadius(
                                cornerRadius: Sizes.s8, cornerSmoothing: 2),
                        borderSide: borderSide ??
                            BorderSide(
                                color: appColor(context).appTheme.trans,
                                width: Sizes.s2)),
                    hintText: language(context, hintText),
                    hintStyle: style ??
                        AppCss.lexendRegular13.textColor(
                            textColor ?? appColor(context).appTheme.hintText),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: enabledBorder ??
                            SmoothBorderRadius(
                                cornerRadius: Sizes.s8, cornerSmoothing: 2),
                        borderSide: BorderSide(
                            width: Sizes.s2,
                            color: appColor(context).appTheme.trans)),
                    prefixIcon: prefixIcon,
                    prefix: prefix,
                    suffix: suffix,
                    suffixIcon: suffixIcon))
        .decorated(boxShadow: [
      BoxShadow(
          color: appColor(context).appTheme.primary.withValues(alpha: 0.03),
          blurRadius: 20,
          spreadRadius: 7)
    ]);
  }
}
