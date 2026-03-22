import 'package:skolo_driver/config.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmationDialog(
      {super.key,
      required this.message,
      required this.onConfirm,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Insets.i16)),
        child: Container(
            padding: EdgeInsets.all(Insets.i16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Insets.i10),
                color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(message,
                      textAlign: TextAlign.center,
                      style: AppCss.lexendRegular14.textHeight(1.3))
                  .marginOnly(top: Insets.i10),
              VSpace(Insets.i30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                    child: CommonButton(
                        onTap: onConfirm,
                        style:
                            AppCss.lexendMedium14.textColor(appTheme.primary),
                        text: appFonts.yes,
                        color: appTheme.stroke)),
                SizedBox(width: Insets.i15),
                Expanded(
                    child: CommonButton(
                        onTap: onCancel,
                        style: AppCss.lexendMedium14.textColor(appTheme.white),
                        text: appFonts.no))
              ])
            ])));
  }
}
