import '../../config.dart';

class SignInProvider extends ChangeNotifier {
  String countryCode = "";
  TextEditingController signInController = TextEditingController();
  //change country code
  onCountryCode(String? dialCode) {
    debugPrint("dial code==>$dialCode");
    notifyListeners();
  }
}
