
import 'dart:developer';

import '../../config.dart';
import 'language_helper.dart';


class LanguageProvider with ChangeNotifier {

  final SharedPreferences sharedPreferences;

  bool get isUserRTl => sharedPreferences.getBool("isUserRTL") ?? false;

  TextDirection get data => isUserRTl ? TextDirection.rtl : TextDirection.ltr;
  Future<void> switchRTL() async {
    sharedPreferences.setBool("isUserRTL", isUserRTl ? false : true);
    notifyListeners();
  }

  TextDirection get textDirection  => isUserRTl
      ? TextDirection.rtl
      : TextDirection.ltr;
  String currentLanguage = appFonts.english;
  Locale? locale;
  int selectedIndex = 0;


  LanguageProvider(this.sharedPreferences) {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
    log("fdhjgfthj : $selectedLocale");
    if (selectedLocale != null) {

      locale = Locale(selectedLocale);
    } else {
      selectedLocale = "English";
      locale = const Locale("en");
    }
    setVal(selectedLocale);
  }

  LanguageHelper languageHelper = LanguageHelper();

  void changeLocale(String newLocale) {
    log("sharedPreferences a1: $newLocale");
    Locale convertedLocale;

    currentLanguage = newLocale;
    log("CURRENT $currentLanguage");
    convertedLocale = languageHelper.convertLangNameToLocale(newLocale);

    locale = convertedLocale;
    log("CURRENT LOCAL $locale");
    sharedPreferences.setString('selectedLocale', locale!.languageCode.toString());
    notifyListeners();
  }

  getLocal() {
    var selectedLocale = sharedPreferences.getString("selectedLocale");
   return selectedLocale;

  }

  defineCurrentLanguage(context) {
    String? definedCurrentLanguage;

    if (currentLanguage.isNotEmpty) {
      definedCurrentLanguage = currentLanguage;
    } else {
      definedCurrentLanguage = languageHelper
          .convertLocaleToLangName(Localizations.localeOf(context).toString());
    }
    return definedCurrentLanguage;
  }

  setVal(value) {
    if (value == "en") {
      currentLanguage = "english";
    } else if (value == "fr") {
      currentLanguage = "french";
    } else if (value == "hi") {
      currentLanguage = "hindi";
    } else if (value == "ar") {
      currentLanguage = "arabic";
    } else {
      currentLanguage = "english";
    }
    notifyListeners();
    changeLocale(currentLanguage);
  }
}
