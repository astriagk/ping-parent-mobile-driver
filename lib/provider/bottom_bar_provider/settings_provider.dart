import 'dart:developer';

import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/screens/app_pages/app_settings/layout/common_draggable_sheet.dart';
import 'package:skolo_driver/data/datasources/remote/auth_service.dart';
import 'package:skolo_driver/data/datasources/remote/api_client.dart';

class SettingProvider extends ChangeNotifier {
  List settings = [];

  List currencyList = [];
  String? selectedCurrencyOption;
  String? selectedLanguageOption;
  List languageList = [];

  // list initialization
  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currencyList = appArray.currencyList;
    languageList = appArray.languageList;
    selectedCurrencyOption =
        prefs.getString('selectedCurrency') ?? currencyList[0]['title'];
    selectedCurrencyOption =
        prefs.getString('selectedLanguage') ?? currencyList[0]['title'];
    notifyListeners();
  }

  //setting screen onTap
  settingsOnTap(e, a, context) {
    if (language(context, a['subTitle']) ==
        language(context, appFonts.profileSettings)) {
      route.pushNamed(context, AppRoute.profile.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.myWallet)) {
      route.pushNamed(context, AppRoute.myWallet.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.bankDetail)) {
      route.pushNamed(context, AppRoute.bankDetails.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.offerList)) {
      route.pushNamed(context, AppRoute.offerList.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.appSettings)) {
      route.pushNamed(context, AppRoute.appSettings.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.documentRegistration)) {
      route.pushNamed(context, AppRoute.documentUpdate.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.userRegistration)) {
      route.pushNamed(context, AppRoute.userUpdate.path);
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.deleteAccount)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmationDialog(
                message: "Are you sure you want to delete account ?",
                onConfirm: () {
                  route.pop(context);
                },
                onCancel: () {
                  route.pop(context);
                });
          });
    }
    if (language(context, a['subTitle']) ==
        language(context, appFonts.logout)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmationDialog(
                message: "Are you sure you want to Logout ?",
                onConfirm: () {
                  route.pop(context);
                  final authService = AuthService(ApiClient());
                  authService.logout().then((_) {
                    if (context.mounted) {
                      route.pushReplacementNamed(context, AppRoute.signIn.path);
                    }
                  });
                },
                onCancel: () {
                  route.pop(context);
                });
          });
    }
  }

  Future<void> saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  //app settings
  int selectIndex = 0;

//top up wallet balance
  int selectedIndex = 0;

  bool isNotification = false;
  bool isNotificationSwitch = true;

  //paymentNotification switch
  notificationSwitch() {
    isNotification = !isNotification;
    notifyListeners();
  }

//Radio button onTap
  commonOnTap(index, e, context) {
    if (index == 1) {
      onChangeButton(e.key);
    }
    if (index == 2) {
      onLanguageChangeButton(e.key);
    }
    notifyListeners();
  }

  commonModelUpdateOnTap(index, context) {
    if (index == 1) {
      currencyChangeValue(context);
    }
    if (index == 2) {
      languageChangeValue(context);
    }
    notifyListeners();
  }

//change currency button
  onChangeButton(index) async {
    selectIndex = index;
    notifyListeners();
  } //change currency button

  //Change language button
  onLanguageChangeButton(index) async {
    selectIndex = index;
    notifyListeners();
  }

  //currency change value
  currencyChangeValue(context) {
    notifyListeners();
    selectedCurrencyOption =
        appArray.currencyList[selectIndex]['title'].toString();
    saveSelectedCurrency(selectedCurrencyOption!);
    currency(context).priceSymbol =
        appArray.currencyList[selectIndex]['symbol'].toString();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    currencyData.currency =
        CurrencyModel.fromJson(appArray.currencyList[selectIndex]);
    currencyData.currencyVal =
        double.parse(currencyData.currency!.exchangeRate!);

    currencyData.notifyListeners();
    notifyListeners();
  }

  //language change value
  languageChangeValue(context) {
    var lan = Provider.of<LanguageProvider>(context, listen: false);
    if (appArray.languageList[selectIndex]['title'] == null ||
        appArray.languageList[selectIndex]['title'] == '') {
      // If no language is selected, default to English
      appArray.languageList[selectIndex]['title'] = 'english';
    } else {
      switch (appArray.languageList[selectIndex]['title']) {
        case 'english':
        case 'arabic':
        case 'french':
        case 'spanish':
          lan.changeLocale(
              appArray.languageList[selectIndex]['title'].toString());
          selectedLanguageOption =
              appArray.languageList[selectIndex]['title'].toString();
          // Save the selected language to shared preferences
          saveSelectedLanguage(
              appArray.languageList[selectIndex]['title'].toString());
          break;
        default:
          log("Invalid language: ${appArray.languageList[selectIndex]['title']}");
          selectedLanguageOption =
              appArray.languageList[selectIndex]['title'].toString();
      }
      notifyListeners();
    }

    notifyListeners();
  }

  String capitalize(s) => s[0].toUpperCase() + s.substring(1);

  // Method to save selected currency to shared preferences
  Future<void> saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency);
  }

  //app setting screen onTap
  appSettingOnTap(e, context) {
    switch (e) {
      case 1:
        //COMMON DraggableSheet layout
        CommonDraggableSheet().settingModelLayout(context,
            index: e, arrayList: currencyList, isSvg: true);
        break;
      case 2:
        //COMMON DraggableSheet layout
        CommonDraggableSheet()
            .settingModelLayout(context, index: e, arrayList: languageList);
    }
  }
}
