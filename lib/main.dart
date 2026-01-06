import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'config.dart';

void main() async {
  if (kDebugMode) {
    debugPrint = (message, {wrapWidth}) => {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ThemeService(snapshot.data!)),
                  ChangeNotifierProvider(
                      create: (_) => LanguageProvider(snapshot.data!)),
                  ChangeNotifierProvider(create: (_) => LoadingProvider()),
                  ChangeNotifierProvider(create: (_) => SplashProvider()),
                  ChangeNotifierProvider(create: (_) => SignInProvider()),
                  ChangeNotifierProvider(create: (_) => SignUpProvider()),
                  ChangeNotifierProvider(create: (_) => OtpProvider()),
                  ChangeNotifierProvider(create: (_) => OnboardingProvider()),
                  ChangeNotifierProvider(create: (_) => BottomBarProvider()),
                  ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
                  ChangeNotifierProvider(create: (_) => SettingProvider()),
                  ChangeNotifierProvider(create: (_) => SettingProvider()),
                  ChangeNotifierProvider(create: (_) => ChatProvider()),
                  ChangeNotifierProvider(create: (_) => BankDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => OfferListProvider()),
                  ChangeNotifierProvider(create: (_) => SaveLocationProvider()),
                  ChangeNotifierProvider(create: (_) => MyWalletProvider()),
                  ChangeNotifierProvider(create: (_) => CurrencyProvider()),
                  ChangeNotifierProvider(create: (_) => NotificationProvider()),
                  ChangeNotifierProvider(create: (_) => MyRidesProvider()),
                  ChangeNotifierProvider(create: (_) => RideDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => ActiveRideProvider()),
                ],
                child: Consumer<ThemeService>(
                    builder: (context, themeService, child) {
                  return Consumer<LanguageProvider>(
                      builder: (context, lang, child) {
                    return ScreenUtilInit(builder: (context, child) {
                      return MaterialApp(
                          title: appFonts.taxify,
                          debugShowCheckedModeBanner: false,
                          theme: AppTheme.fromType(ThemeType.light).themeData,
                          darkTheme:
                              AppTheme.fromType(ThemeType.dark).themeData,
                          supportedLocales: appArray.localList,
                          themeMode: themeService.theme,
                          initialRoute: "/",
                          routes: appRoute.route,
                          locale: lang.locale,
                          localizationsDelegates: const [
                            AppLocalizations.delegate,
                            AppLocalizationDelagate(),
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate
                          ]);
                    });
                  });
                }));
          } else {
            return const MaterialApp(
                debugShowCheckedModeBanner: false, home: SplashScreenLayout());
          }
        });
  }
}
