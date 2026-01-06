import '../../../config.dart';

class OTPScreenWidgets {
  Widget pinPutLayout() {
    return Consumer<OtpProvider>(builder: (context, otpCtrl, child) {
      return Pinput(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              controller: otpCtrl.pinController,
              length: 5,
              focusNode: otpCtrl.focusNode,
              isCursorAnimationEnabled: false,
              /* validator: (value) {
                return value == '22222'
                    ? null
                    : value!.isEmpty
                        ? appFonts.pleaseFillTheOTP
                        : appFonts.pinIsIncorrect;
              },*/
              onClipboardFound: (value) => otpCtrl.pinController.setText(value),
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
    });
  }
}
