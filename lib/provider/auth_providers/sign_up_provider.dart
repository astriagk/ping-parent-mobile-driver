import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config.dart';

class SignUpProvider extends ChangeNotifier {
  int index = 0;
  final List<String> rules = [
    appFonts.maxInBack,
    appFonts.carsAreNotPermitted,
    appFonts.iApologize,
    appFonts.pleaseNoSmoking,
    appFonts.noAlcoholClosed,
  ];

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

  onChange(value) {
    selectedVehicle = value;
    notifyListeners();
  }

  dynamic selectedVehicle;

  final List<Map<String, dynamic>> vehicles = [
    {'name': appFonts.bike, 'image': 'assets/image/auth/bike.png'},
    {'name': appFonts.car, 'image': 'assets/image/auth/car.png'},
    {'name': appFonts.van, 'image': 'assets/image/auth/van.png'},
    {'name': appFonts.truck, 'image': 'assets/image/auth/truck.png'}
  ];

  // Track selected vehicle
  int selectedIndex = 0;

  List<bool> isChecked = [];

  onInit() {
    isChecked = List<bool>.filled(rules.length, false);
    selectedVehicle = vehicleDropDownItems[0]['value'];
  }

  File? image;

  Future<void> pickImage(
    context,
    /* {required ImageSource source}*/
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language(context, appFonts.upload),
                              style: AppCss.lexendMedium16
                                  .textColor(appTheme.primary)),
                          CommonIconButton(
                              icon: svgAssets.close,
                              onTap: () => route.pop(context))
                        ]),
                    SizedBox(height: Insets.i20),
                    ListTile(
                        leading:
                            Icon(Icons.photo_library, color: appTheme.primary),
                        title: Text(
                            language(context, appFonts.selectFromGallery),
                            style: AppCss.lexendMedium16
                                .textColor(appTheme.primary)),
                        onTap: () => route.pop(context)),
                    ListTile(
                        leading:
                            Icon(Icons.camera_alt, color: appTheme.primary),
                        title: Text(language(context, appFonts.openCamera),
                            style: AppCss.lexendMedium16
                                .textColor(appTheme.primary)),
                        onTap: () => route.pop(context))
                  ])));
        });

    /* PermissionStatus status = await Permission.photos.request();
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }
    log("permission hello $status");
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 800,
          maxWidth: 800);

      if (pickedFile != null) {
        notifyListeners();
        image = File(pickedFile.path);
        notifyListeners();
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission denied. Cannot pick image.',
              style: AppCss.lexendRegular16.textColor(appTheme.darkText))));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }*/
  }

  index0BackTap(context) {
    route.pop(context);
    notifyListeners();
  }

  index1BackTap(context) {
    index = 0;
    notifyListeners();
  }

  index2BackTap(context) {
    index = 1;
    notifyListeners();
  }

  index3BackTap(context) {
    index = 2;
    notifyListeners();
  }

  /*vehicleChooseOnTap() {
    selectedIndex = index;
    notifyListeners();
  }*/

  signUpButton() {
    index = 1;
    notifyListeners();
  }

  alreadyHavingAccountSignInButton(context) {
    route.pushNamed(context, routeName.signInScreen);
  }

  documentVerifyButton() {
    index = 2;
    notifyListeners();
  }

  vehicleRegButton() {
    index = 3;
    notifyListeners();
  }

  bankDetails(context) {
    route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
    notifyListeners();
  }

  vehiclesRulesOnTap() {
    notifyListeners();
    isChecked[index] = !isChecked[index];
    notifyListeners();
  }
}
