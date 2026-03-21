// ─────────────────────────────────────────────────────────────────────────────
// NEW ARCHITECTURE — lib/core/ (Clean Architecture, feature-first)
// ─────────────────────────────────────────────────────────────────────────────

export 'package:skolo_driver/core/assets/index.dart';
export 'package:skolo_driver/core/constants/app_array.dart';
export 'package:skolo_driver/core/constants/session.dart';
export 'package:skolo_driver/core/extensions/index.dart';
export 'package:skolo_driver/core/languages/app_fonts.dart';
export 'package:skolo_driver/core/languages/app_language.dart';
export 'package:skolo_driver/core/languages/language_change.dart';
export 'package:skolo_driver/core/responsive/flutter_screen_util.dart';
export 'package:skolo_driver/core/theme/index.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OLD ARCHITECTURE — to be migrated
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:io';

import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/home_screen/layouts/home_screen_widget.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/my_rides_widgets.dart';
import 'package:skolo_driver/widgets/screens_widgets/screens_widgets.dart';

import 'config.dart';

export 'package:flutter/gestures.dart';
export 'package:flutter/material.dart';
export 'package:flutter/physics.dart';

export 'package:skolo_driver/core/utils/navigation_class.dart';
export 'package:skolo_driver/models/index.dart';
export 'package:skolo_driver/package_list.dart';
export 'package:skolo_driver/provider/index.dart';
export 'package:skolo_driver/routes/index.dart';
export 'package:skolo_driver/routes/screen_list.dart';
export 'package:skolo_driver/screens/index.dart';
export 'package:skolo_driver/widgets/index.dart';
export 'package:skolo_driver/widgets/skeletons/index.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GLOBALS
// ─────────────────────────────────────────────────────────────────────────────

Session session = Session();
AppFonts appFonts = AppFonts();
NavigationClass route = NavigationClass();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
AppArray appArray = AppArray();
AppCss appCss = AppCss();
ScreensWidgets screensWidgets = ScreensWidgets();
MyRidesWidgets myRidesWidgets = MyRidesWidgets();
HomeScreenWidget homeScreenWidget = HomeScreenWidget();

AppTheme get appTheme => _appTheme;
AppTheme _appTheme = AppTheme.fromType(ThemeType.light);

ThemeService appColor(context) {
  final themeServices = Provider.of<ThemeService>(context, listen: false);
  return themeServices;
}

CurrencyProvider currency(context) {
  final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
  return currencyData;
}

getSymbol(context) {
  final currencyData =
      Provider.of<CurrencyProvider>(context, listen: false).priceSymbol;

  return currencyData;
}

showLoading(context) async {
  Provider.of<LoadingProvider>(context, listen: false).showLoading();
}

hideLoading(context) async {
  Provider.of<LoadingProvider>(context, listen: false).hideLoading();
}

String language(context, text) {
  return AppLocalizations.of(context)!.translate(text);
}

Future<bool> isNetworkConnection() async {
  var connectivityResult = await Connectivity()
      .checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
