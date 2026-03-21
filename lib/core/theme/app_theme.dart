import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;

  //Theme Colors

  bool isDark;
  Color primary;
  Color darkText;
  Color lightText;
  Color screenBg;
  Color screenDarkBg;
  Color trans;
  Color yellowIcon;
  Color bgBox;
  Color hintText;
  Color white;
  Color borderColor;
  Color stroke;
  Color alertZone;
  Color onBoardingBg;
  Color onCtrClr;
  Color descrTextClr;
  Color textClr;
  Color walletClr;
  Color priceClr;
  Color online;
  Color feedbackText;
  Color dialogButtonClr;

  Color selectedCountry;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.primary,
    required this.darkText,
    required this.lightText,
    required this.screenBg,
    required this.trans,
    required this.screenDarkBg,
    required this.yellowIcon,
    required this.bgBox,
    required this.hintText,
    required this.white,
    required this.borderColor,
    required this.stroke,
    required this.alertZone,
    required this.onBoardingBg,
    required this.onCtrClr,
    required this.descrTextClr,
    required this.textClr,
    required this.walletClr,
    required this.priceClr,
    required this.online,
    required this.feedbackText,
    required this.dialogButtonClr,
    required this.selectedCountry,
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
            isDark: false,
            primary: const Color(0xff171C26),
            darkText: const Color(0xff171C26),
            lightText: const Color(0xFFA2A4A8),
            screenBg: const Color(0xffFFFFFF),
            screenDarkBg: const Color(0xff171C26),
            trans: Colors.transparent,
            yellowIcon: const Color(0xFFFFB400),
            bgBox: const Color(0xFFF3F4F6),
            hintText: const Color(0xFFA2A4A8),
            white: const Color(0xffFFFFFF),
            borderColor: const Color(0xFFEFEFEF),
            stroke: const Color(0xFFE8E8E9),
            alertZone: const Color(0xFFFF4B4B),
            onBoardingBg: const Color(0xFFF1F1F1),
            textClr: const Color(0xFF797D83),
            online: Colors.green,
            onCtrClr: const Color(0xFF1F1F1F),
            descrTextClr: const Color(0xFF8F8F8F),
            walletClr: const Color(0xff808B97),
            priceClr: Color(0xff20B149),
            feedbackText: Color(0xff00162E),
            dialogButtonClr: Color(0xffF5F5F5),
            selectedCountry: Color(0xffA2A4A8));

      case ThemeType.dark:
        return AppTheme(
            isDark: true,
            primary: const Color(0xff622CFD),
            darkText: const Color(0xff171C26),
            lightText: const Color(0xFFA2A4A8),
            screenBg: const Color(0xFF17161B),
            screenDarkBg: const Color(0xff171C26),
            trans: Colors.transparent,
            yellowIcon: const Color(0xFFFFB400),
            bgBox: const Color(0xFFF3F4F6),
            hintText: const Color(0xFFA2A4A8),
            white: const Color(0xffFFFFFF),
            borderColor: const Color(0xFFEFEFEF),
            stroke: const Color(0xFFE8E8E9),
            alertZone: const Color(0xFFFF4B4B),
            online: Colors.green,
            onBoardingBg: const Color(0xFFF1F1F1),
            textClr: const Color(0xff797D83),
            onCtrClr: const Color(0xFF1F1F1F),
            descrTextClr: const Color(0xFF8F8F8F),
            walletClr: const Color(0xff808B97),
            priceClr: Color(0xff20B149),
            feedbackText: Color(0xff00162E),
            dialogButtonClr: Color(0xffF5F5F5),
            selectedCountry: Color(0xffA2A4A8));
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
        textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
        useMaterial3: true,
        colorScheme: ColorScheme(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primary: primary,
            secondary: primary,
            surface: screenBg,
            onSurface: screenBg,
            onError: Colors.red,
            onPrimary: primary,
            tertiary: screenBg,
            onInverseSurface: screenBg,
            tertiaryContainer: screenBg,
            surfaceTint: screenBg,
            surfaceContainerHighest: screenBg,
            onSecondary: primary,
            error: Colors.red));
    return t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent, cursorColor: primary),
      buttonTheme: ButtonThemeData(buttonColor: primary),
      highlightColor: primary,
    );
  }
}
