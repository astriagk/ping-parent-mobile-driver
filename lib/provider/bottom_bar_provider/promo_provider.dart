import '../../config.dart';

class OfferListProvider extends ChangeNotifier {
  List promoList = [];

  bool isOfferActive = false;

  //List initialization
  init() {
    // promoList = appArray.promoList;
    notifyListeners();
  }

  void updateIsActive(int index, bool newValue) {
    appArray.offersList[index]["isActive"] = newValue;
    notifyListeners();
  }

  void deleteOffer(int index) {
    appArray.offersList.removeAt(index);
    notifyListeners();
  }

  activeStatusTap() {
    isOfferActive = !isOfferActive;
    notifyListeners();
  }

  List vehicleDropDownItems = [
    {'value': 1, 'label': '1'},
    {'value': 2, 'label': '2'},
    {'value': 3, 'label': '3'},
    {'value': 4, 'label': '4'},
    {'value': 5, 'label': '5'},
  ];

  List area = [
    {'value': 1, 'label': 'M'},
    {'value': 2, 'label': 'KM'},
  ];

  onChangeArea(value) {
    selectedArea = value;
    notifyListeners();
  }

  onChange(value) {
    selectedSeats = value;
    notifyListeners();
  }

  dynamic selectedSeats, selectedArea;
}
