import 'package:flutter/cupertino.dart';

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //show loading
  void showLoading() {
    _isLoading = true;
    notifyListeners();
  }

//hide loading
  void hideLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
