import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/common_app_bar.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  const CommonBottomNavigationBar({super.key});

  @override
  State<CommonBottomNavigationBar> createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, bottomNavPvr, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150)
              .then((value) => bottomNavPvr.notifyListeners()),
          child: Scaffold(
              appBar: DashAppBar(index: bottomNavPvr.currentIndex),
              body: SafeArea(
                  child: SingleChildScrollView(
                      child: bottomNavPvr.screens[bottomNavPvr.currentIndex])),
              bottomNavigationBar: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: Insets.i10),
                  width: double.infinity,
                  height: Insets.i76,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color:
                                appTheme.screenDarkBg.withValues(alpha: 0.12),
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                            blurRadius: AppRadius.r22)
                      ],
                      border: Border.all(color: appTheme.primary),
                      color: appTheme.primary,
                      borderRadius: const SmoothBorderRadius.vertical(
                          top: SmoothRadius(
                              cornerRadius: 20, cornerSmoothing: 0))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        bottomNavPvr.buildNavItem(
                            0,
                            language(context, appFonts.home),
                            svgAssets.homeDark,
                            svgAssets.homeLight),
                        bottomNavPvr.buildNavItem(
                            1,
                            language(context, appFonts.activeRide),
                            svgAssets.driving,
                            svgAssets.driving1),
                        bottomNavPvr.buildNavItem(
                            2,
                            language(context, appFonts.myRides),
                            svgAssets.carDark,
                            svgAssets.carLight),
                        bottomNavPvr.buildNavItem(
                            3,
                            language(context, appFonts.settings),
                            svgAssets.settingDark,
                            svgAssets.settingLight)
                      ]))));
    });
  }
}
