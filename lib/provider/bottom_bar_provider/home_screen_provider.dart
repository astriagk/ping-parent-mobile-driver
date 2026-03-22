import '../../config.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isToggled = false;

  toggleOnTap() {
    isToggled = !isToggled;
    notifyListeners();
  }

  activeOfferToggle(offer) {
    offer['isToggled'] = !offer['isToggled'];
    notifyListeners();
  }

  deleteOnTap(index) {
    appArray.offers.removeAt(index);
    notifyListeners();
  }

  editOnTap(context) {
    route.pushNamed(context, AppRoute.createOffer.path);
  }
}
