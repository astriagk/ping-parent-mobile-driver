import '../../api/api_client.dart';
import '../../api/services/user_details_service.dart';
import '../../config.dart';
import '../../screens/bottom_navigation_bar/layouts/active_ride_screen/active_ride_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/home_screen/home_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/my_rides_screen/my_rides_screen.dart';
import '../../screens/bottom_navigation_bar/layouts/settings_screen/settings_screen.dart';

class BottomBarProvider extends ChangeNotifier {
  int currentTab = 0;
  bool isImage = true;
  bool isAvailable = false;
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

  void setAvailability(bool value) {
    isAvailable = value;
    notifyListeners();
  }

  /// Toggle driver availability and call PATCH /driver/availability
  Future<void> toggleAvailability() async {
    final newValue = !isAvailable;
    isAvailable = newValue;
    notifyListeners();

    try {
      final service = UserDetailsService(ApiClient());
      final result = await service.updateDriverAvailability(newValue);
      if (result['success'] != true) {
        // Revert on failure
        isAvailable = !newValue;
        notifyListeners();
      }
    } catch (_) {
      isAvailable = !newValue;
      notifyListeners();
    }
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
