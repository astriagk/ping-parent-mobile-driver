import '../../config.dart';

class NotificationProvider extends ChangeNotifier {
  List notification = [];
  //list initialization
  init() {
    notification = appArray.notification;
    notifyListeners();
  }
}
