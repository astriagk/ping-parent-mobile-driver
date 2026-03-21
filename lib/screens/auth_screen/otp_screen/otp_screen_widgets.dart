import '../../../config.dart';

class OTPScreenWidgets {
  /// Renders a standard 6-digit Pinput.
  /// Pass [controller] to use a custom controller; otherwise uses [OtpProvider].
  Widget pinPutLayout({TextEditingController? controller}) {
    if (controller != null) {
      return Builder(builder: (context) {
        return _buildPinput(context, controller,
            onClipboard: (value) => controller.setText(value));
      });
    }
    return Consumer<OtpProvider>(builder: (context, otpCtrl, child) {
      return _buildPinput(context, otpCtrl.pinController,
          focusNode: otpCtrl.focusNode,
          onClipboard: (value) => otpCtrl.pinController.setText(value));
    });
  }

  Widget _buildPinput(
    BuildContext context,
    TextEditingController controller, {
    FocusNode? focusNode,
    void Function(String)? onClipboard,
  }) {
    return Pinput(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            controller: controller,
            length: 6,
            focusNode: focusNode,
            isCursorAnimationEnabled: false,
            onClipboardFound: onClipboard,
            defaultPinTheme: PinTheme(
                height: Sizes.s50,
                width: Sizes.s50,
                decoration: BoxDecoration(
                    color: appColor(context).appTheme.white,
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: Sizes.s8, cornerSmoothing: 2)),
                textStyle: AppCss.lexendRegular16
                    .textColor(appColor(context).appTheme.darkText)))
        .decorated(boxShadow: [
      BoxShadow(
          color: appColor(context).appTheme.primary.withValues(alpha: 0.03),
          blurRadius: 20,
          spreadRadius: 7)
    ]).center();
  }
}
