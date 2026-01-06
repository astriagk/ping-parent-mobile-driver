import 'package:taxify_driver_ui/config.dart';

class OtpProvider extends ChangeNotifier {
  TextEditingController pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  backOnTap(context) {
    pinController.text = "";
    route.pop(context);
    notifyListeners();
  }

  verifyOtp(context) {
    route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
    notifyListeners();
  }

  exitPopUpAlert(didPop, context) {
    if (didPop) return;
    pinController.text = "";
    route.pop(context);
  }
}
