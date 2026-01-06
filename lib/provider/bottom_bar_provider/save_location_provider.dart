

import '../../config.dart';

class SaveLocationProvider extends ChangeNotifier{
  List saveLocationList = [];
  //list initialization
  init(){
    saveLocationList =appArray.saveLocation;
    notifyListeners();
  }
}