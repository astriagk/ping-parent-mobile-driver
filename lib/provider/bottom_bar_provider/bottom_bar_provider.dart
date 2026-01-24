import '../../config.dart';
import '../../screens/bottom_navigation_bar/layouts/active_ride_screen/active_ride_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/home_screen/home_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/my_rides_screen/my_rides_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/settings_screen/settings_screen.dart';

class BottomBarProvider extends ChangeNotifier {
  int currentTab = 0;
  bool isImage = true;
  List<dynamic> bottomNavigationBarList = [];
  ScrollController? scrollViewController;

  final List<Widget> screens = [
    const HomeScreen(),
    const ActiveRideScreen(),
    const MyRidesScreen(),
    const SettingsScreen(),
  ];

  /// Initialize on first load - loads data from data layer
  void onInit() {
    bottomNavigationBarList = appArray.bottomNavigationBarList;
    scrollViewController = ScrollController(initialScrollOffset: 0.0);
    scrollViewController!.addListener(changeColor);
    notifyListeners();
  }

  /// Handle scroll events for home screen animations
  void changeColor() {
    if ((scrollViewController!.offset == 0)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 80)) {
      isImage = true;
    } else if ((scrollViewController!.offset <= 100)) {
      isImage = false;
    }
    notifyListeners();
  }

  /// Main tab switching logic - optimized for instant response
  void tabChange(int index) {
    if (currentTab != index) {
      currentTab = index;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollViewController?.dispose();
    super.dispose();
  }
}
