import 'dart:io';
// Provides access to input and output operations, including file, socket, HTTP, and more.

import 'package:taxify_driver_ui/common/app_fonts.dart';
// Manages custom fonts used throughout the application.

import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/home_screen/layouts/home_screen_widget.dart';
// Widgets for the home screen layout.

import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/my_rides_screen/layouts/my_rides_widgets.dart';
// Widgets related to the "My Rides" screen layout.

import 'package:taxify_driver_ui/widgets/screens_widgets/screens_widgets.dart';
// General reusable screen-related widgets.

import 'config.dart';
// Local configuration file, possibly containing environment variables and app settings.

export 'package:flutter/gestures.dart';
// Enables gesture detection like tap, swipe, and long press.

export 'package:flutter/material.dart';
// The core Flutter UI framework for building user interfaces.

export 'package:flutter/physics.dart';
// Provides physics simulations for animations.

export 'package:taxify_driver_ui/common/assets/index.dart';
// Manages app-wide assets like images and icons.

export 'package:taxify_driver_ui/common/index.dart';
// Centralized common utilities and helper functions.

export 'package:taxify_driver_ui/helper/navigation_class.dart';
// Navigation helper class to manage routing.

export 'package:taxify_driver_ui/models/index.dart';
// Data models used within the application.

export 'package:taxify_driver_ui/package_list.dart';
// List of third-party packages used in the project.

export 'package:taxify_driver_ui/provider/index.dart';
// State management providers.

export 'package:taxify_driver_ui/routes/index.dart';
// App routes configuration.

export 'package:taxify_driver_ui/routes/screen_list.dart';
// Defines screens available for navigation.

export 'package:taxify_driver_ui/screens/index.dart';
// Collection of all screens in the app.

export 'package:taxify_driver_ui/widgets/index.dart';
// Collection of reusable widgets.

// skeletons
export 'package:taxify_driver_ui/widgets/skeletons/index.dart';

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
      .checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    final result = await InternetAddress.lookup(
        'google.com'); //Check For Internet Connection
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
