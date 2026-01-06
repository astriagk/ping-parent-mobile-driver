import 'package:flutter/cupertino.dart';

class BankDetailsProvider extends ChangeNotifier {
  TextEditingController bankName = TextEditingController();
  TextEditingController holderName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController swiftCode = TextEditingController();
  dynamic branch;

  //select card number dropDown layout
  List branchDropDownItems = [
    {'value': 1, 'label': 'katargam'},
    {'value': 2, 'label': 'varachha'},
    {'value': 3, 'label': 'singanpor'}
  ];

//controller initialization
  init() {
    bankName.text = "DBS Bank";
    holderName.text = "Zain Dorwart";
    accountNo.text = "1256 2635 8956";
    ifscCode.text = "DBSS0IN0831";
    swiftCode.text = "DBSSINBB";
    branch = branchDropDownItems[1]['value'];
    notifyListeners();
  }

  //state change value
  branchChange(newValue) {
    branch = newValue;
    notifyListeners();
  }

  onChange(value) {
    selectedVehicle = value;
    notifyListeners();
  }

  dynamic selectedVehicle;

  List vehicleDropDownItems = [
    {'value': 1, 'label': 'Electric Mountain Bike'},
    {'value': 2, 'label': 'Hybrid SUV'},
    {'value': 3, 'label': 'Convertible Sports Car'},
    {'value': 4, 'label': 'Cargo Minivan'},
    {'value': 5, 'label': 'Electric Pickup Truck'},
    {'value': 6, 'label': 'Luxury Camper Van'},
    {'value': 7, 'label': 'Off-Road SUV'},
    {'value': 8, 'label': 'Refrigerated Box Truck'},
    {'value': 9, 'label': 'Adventure Touring Motorcycle'},
    {'value': 10, 'label': 'Compact Cargo Van'},
    {'value': 11, 'label': 'Monster Pickup Truck'},
    {'value': 12, 'label': 'Electric Road Bike'},
    {'value': 13, 'label': 'Luxury SUV'},
    {'value': 14, 'label': 'Mini Tow Truck'},
    {'value': 15, 'label': 'Hybrid Coupe'},
  ];

  ///
  ///
  List<bool> isChecked = [];

  onInit() {
    isChecked = List<bool>.filled(rules.length, false);
    notifyListeners();
  }

  final List<String> rules = [
    "Max, 2 In The Back",
    "Cars Are Not Permitted To Be Used For Eating",
    "I Apologize, But This Is Not A Pet",
    "Please, No Smoking In The Car",
    "No Alcohol Closed/Open",
  ];
}
