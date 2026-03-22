import 'package:flutter/services.dart';
import 'package:skolo_driver/config.dart';

/// Molecule — Label text above a text field.
///
/// Fully prop-driven. No Riverpod access.
class LabeledTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final Color? labelColor;
  final Color? fieldColor;
  final Widget? prefixIcon;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  const LabeledTextField({
    super.key,
    this.label,
    this.hintText,
    this.labelColor,
    this.fieldColor,
    this.prefixIcon,
    this.style,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidgetCommon(text: label, color: labelColor),
        VSpace(Sizes.s9),
        TextFieldCommon(
            controller: controller,
            inputFormat: inputFormatters,
            keyboardType: keyboardType,
            style: style,
            prefixIcon: prefixIcon,
            hintText: hintText,
            color: fieldColor ?? appColor(context).appTheme.screenBg),
      ],
    );
  }
}
