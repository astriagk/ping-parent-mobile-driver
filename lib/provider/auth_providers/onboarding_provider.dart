import 'dart:io';
import '../../config.dart';

class OnboardingProvider extends ChangeNotifier {
  // Intro onboarding (initial slides)
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<String> images = [
    imageAssets.onBoarding,
    imageAssets.onBoarding1,
    imageAssets.onBoarding2
  ];
  final List<String> titles = [
    appFonts.trackingRealtime,
    appFonts.earnMoney,
    appFonts.becomeTaxify
  ];

  // Signup onboarding (documents, vehicle, bank)
  // Removed signupOnboardingIndex - now using routing instead
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

  int selectedIndex = 0;
  List<bool> isChecked = [];

  File? image;

  onInit() {
    isChecked = List<bool>.filled(rules.length, false);
    selectedVehicle = vehicleDropDownItems[0]['value'];
  }

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
  }

  // Intro onboarding methods
  onboardingOnTap(context) {
    if (currentIndex < images.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      route.pushReplacementNamed(context, routeName.signInScreen);
    }
  }

  onPageChanged(index) {
    notifyListeners();
    currentIndex = index;
  }

  // Signup onboarding methods (routing-based)
  documentVerifyButton(context) {
    route.pushNamed(context, routeName.vehicleOnboarding);
  }

  vehicleRegButton(context) {
    route.pushNamed(context, routeName.bankOnboarding);
  }

  bankDetails(context) {
    // Navigate to dashboard after completing onboarding
    route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
  }

  vehiclesRulesOnTap(int ruleIndex) {
    isChecked[ruleIndex] = !isChecked[ruleIndex];
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
