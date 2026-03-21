import 'package:skolo_driver/config.dart';

import 'language_helper.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  bool get isUserRTl => sharedPreferences.getBool("isUserRTL") ?? false;

  TextDirection get data => TextDirection.ltr;

  Future<void> switchRTL() async {
    sharedPreferences.setBool("isUserRTL", false);
    notifyListeners();
  }

  TextDirection get textDirection => TextDirection.ltr;

  String currentLanguage = appFonts.english;
  Locale? locale;
  int selectedIndex = 0;

  LanguageProvider(this.sharedPreferences) {
    locale = const Locale("en");
    currentLanguage = "english";
  }

  LanguageHelper languageHelper = LanguageHelper();

  void changeLocale(String newLocale) {
    currentLanguage = "english";
    locale = const Locale('en', 'EN');
    sharedPreferences.setString('selectedLocale', 'en');
    notifyListeners();
  }

  getLocal() => sharedPreferences.getString("selectedLocale");

  defineCurrentLanguage(context) => "english";

  setVal(value) {
    currentLanguage = "english";
    notifyListeners();
    changeLocale(currentLanguage);
  }
}
