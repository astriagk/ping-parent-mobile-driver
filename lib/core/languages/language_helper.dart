import 'package:flutter/material.dart';

class LanguageHelper {
  Locale convertLangNameToLocale(String langNameToConvert) {
    return const Locale('en', 'EN');
  }

  String convertLocaleToLangName(String localeToConvert) {
    return "English";
  }
}
