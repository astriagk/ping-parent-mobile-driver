
import '../../config.dart';


class CurrencyProvider with ChangeNotifier {
  CurrencyModel? currency;
  double currencyVal =
      double.parse(appArray.currencyList[0]["exchange_rate"].toString())
          .roundToDouble();
  String priceSymbol = "\$";

  // set currency
  setVal() {
    priceSymbol = currency!.symbol!;
    notifyListeners();
  }
}
