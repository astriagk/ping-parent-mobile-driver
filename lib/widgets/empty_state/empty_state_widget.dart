import 'package:taxify_driver_ui/config.dart';

/// A reusable empty state widget that displays an image, title, message, and optional action button.
/// Use this for error states, empty lists, no data scenarios, etc.
/// Follows the same styling as EmptyNotification screen.
class EmptyStateWidget extends StatelessWidget {
  /// Default empty state image path
  static const String defaultImagePath = 'assets/image/home/empty.png';

  /// The image asset path to display (defaults to empty.png)
  final String imagePath;

  /// The title text (defaults to "Nothing Here")
  final String? title;

  /// The description/message text (defaults to "Click the refresh")
  final String? message;

  /// Optional button text. If null, no button is shown
  final String? buttonText;

  /// Optional callback for button tap
  final VoidCallback? onButtonTap;

  const EmptyStateWidget({
    super.key,
    this.imagePath = defaultImagePath,
    this.title,
    this.message,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Image.asset(imagePath).padding(vertical: Sizes.s42),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextWidgetCommon(
            text: title ?? appFonts.nothingHere,
            style: AppCss.lexendSemiBold18
                .textColor(appColor(context).appTheme.darkText)),
        VSpace(Sizes.s8),
        TextWidgetCommon(
                text: message ?? appFonts.clickTheRefresh,
                style: AppCss.lexendRegular12
                    .textColor(appColor(context).appTheme.lightText)
                    .textHeight(1.2),
                textAlign: TextAlign.center)
            .padding(horizontal: Sizes.s15),
        if (buttonText != null && onButtonTap != null)
          CommonButton(text: buttonText!, onTap: onButtonTap)
              .padding(bottom: Sizes.s20, top: Sizes.s75)
      ]).padding(horizontal: Sizes.s20)
    ]);
  }
}
