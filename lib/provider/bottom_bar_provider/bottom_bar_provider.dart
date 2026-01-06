import '../../config.dart';
import '../../screens/bottom_navigation_bar/layouts/active_ride_screen/active_ride_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/home_screen/home_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/my_rides_screen/my_rides_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/settings_screen/settings_screen.dart';

class BottomBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const ActiveRideScreen(),
    const MyRidesScreen(),
    const SettingsScreen(),
  ];

  ScrollController? scrollViewController;

  bool isToggled = false;

// Handle bottom tab tapping
  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Widget buildNavItem(
      int index, String label, String activeIcon, String inactiveIcon) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
        onTap: () => onTabTapped(index),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SvgPicture.asset(isSelected ? activeIcon : inactiveIcon),
          SizedBox(height: Insets.i5),
          Text(label,
              style: isSelected
                  ? AppCss.lexendLight14.textColor(appTheme.white)
                  : AppCss.lexendMedium14.textColor(appTheme.textClr))
        ]));
  }

  toggleOnTap() {
    isToggled = !isToggled;
    notifyListeners();
  }
}
