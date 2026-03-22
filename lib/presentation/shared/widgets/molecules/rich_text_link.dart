import 'package:skolo_driver/config.dart';

/// Molecule — A centred line of plain text followed by a tappable link.
///
/// Fully prop-driven. No Riverpod access.
class RichTextLink extends StatelessWidget {
  final String? text;
  final String? linkText;
  final VoidCallback? onTap;

  const RichTextLink({
    super.key,
    this.text,
    this.linkText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: text,
            style: AppCss.lexendRegular12
                .textColor(appColor(context).appTheme.lightText)),
        TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: ' $linkText',
            style: AppCss.lexendRegular12
                .textColor(appColor(context).appTheme.darkText)),
      ]),
    ).center();
  }
}
