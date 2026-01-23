import 'dart:io';
import '../../config.dart';
import '../../api/api_client.dart';
import '../../api/services/onboarding_service.dart';

class OnboardingProvider extends ChangeNotifier {
  late OnboardingService _onboardingService;
  bool isCreatingProfile = false;

  // Text Controllers for user registration
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleCapacityController =
      TextEditingController();

  // Text Controllers for document verification
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController vehicleLicenseNumberController =
      TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();
  final TextEditingController birthCertificateController =
      TextEditingController();

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
    {'name': appFonts.auto, 'image': 'assets/image/auth/van.png'},
    {'name': appFonts.van, 'image': 'assets/image/auth/van.png'},
    {'name': appFonts.bus, 'image': 'assets/image/auth/van.png'}
  ];

  int selectedIndex = 0;
  List<bool> isChecked = [];

  File? image;

  // User Data
  Map<String, dynamic> userData = {
    'name': '',
    'email': '',
    'photo_url': '',
    'vehicle_type': '',
    'vehicle_number': '',
    'vehicle_capacity': 0,
  };

  onInit() {
    isChecked = List<bool>.filled(rules.length, false);
    selectedVehicle = vehicleDropDownItems[0]['value'];
    _onboardingService = OnboardingService(ApiClient());
  }

  void setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }

  Future<void> pickImage(
    context, {
    String? documentName,
  }) async {
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
                          Text(
                              language(context, appFonts.upload) +
                                  (documentName != null
                                      ? ' - $documentName'
                                      : ''),
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

  userRegButton(context) {
    route.pushNamed(context, routeName.documentsOnboarding);
  }

  /// Validates user registration data and calls the API
  Future<void> handleUserRegistration(BuildContext context) async {
    FocusScope.of(context).unfocus();

    // Get values from controllers
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final vehicleNumber = vehicleNumberController.text.trim();
    final vehicleCapacityStr = vehicleCapacityController.text.trim();

    // Get selected vehicle type (from selectedIndex)
    final vehicleType = selectedIndex < vehicles.length
        ? vehicles[selectedIndex]['name']
        : vehicles[0]['name'];

    // Validation
    if (name.isEmpty) {
      _showError(context, 'Please enter your name');
      return;
    }

    if (email.isEmpty) {
      _showError(context, 'Please enter your email');
      return;
    }

    if (!_isValidEmail(email)) {
      _showError(context, 'Please enter a valid email address');
      return;
    }

    if (vehicleNumber.isEmpty) {
      _showError(context, 'Please enter vehicle number');
      return;
    }

    if (vehicleCapacityStr.isEmpty) {
      _showError(context, 'Please enter vehicle capacity');
      return;
    }

    final vehicleCapacity = int.tryParse(vehicleCapacityStr);
    if (vehicleCapacity == null || vehicleCapacity <= 0) {
      _showError(context, 'Please enter a valid vehicle capacity');
      return;
    }

    // Call API to create driver profile
    isCreatingProfile = true;
    notifyListeners();

    final result = await _onboardingService.createDriverProfile(
      name: name,
      email: email,
      photoUrl:
          'https://example.com/photo.jpg', // Empty for now, can be updated with image picker
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleCapacity: vehicleCapacity,
      isAvailable: false,
    );

    isCreatingProfile = false;
    notifyListeners();

    if (!context.mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
            text: result.message ?? 'Driver profile created successfully',
          ),
        ),
      );
      // Navigate to next onboarding screen
      route.pushNamed(context, routeName.documentsOnboarding);
    } else {
      String errorMessage = result.error ?? 'Failed to create driver profile';
      if (result.details != null && result.details!.isNotEmpty) {
        errorMessage = result.details!.join('\n');
      }
      _showError(context, errorMessage);
    }
  }

  /// Validates email format
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Shows error snackbar
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidgetCommon(text: message),
        backgroundColor: Colors.red,
      ),
    );
  }

  documentVerifyButton(context) {
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

  /// Create driver profile and handle result UI logic
  Future<void> createDriverProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();

    isCreatingProfile = true;
    notifyListeners();

    final result = await _onboardingService.createDriverProfile(
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      photoUrl: userData['photo_url'] ?? '',
      vehicleType: userData['vehicle_type'] ?? '',
      vehicleNumber: userData['vehicle_number'] ?? '',
      vehicleCapacity: userData['vehicle_capacity'] ?? 0,
      isAvailable: false,
    );

    isCreatingProfile = false;
    notifyListeners();

    if (!context.mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidgetCommon(
            text: result.message ?? 'Driver profile created successfully',
          ),
        ),
      );
      // Navigate to dashboard after successful profile creation
      route.pushNamedAndRemoveUntil(context, routeName.commonBottomBar);
    } else if (result.error != null) {
      String errorMessage = result.error!;
      if (result.details != null && result.details!.isNotEmpty) {
        errorMessage = result.details!.join(', ');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidgetCommon(text: errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    emailController.dispose();
    vehicleNumberController.dispose();
    vehicleCapacityController.dispose();
    drivingLicenseController.dispose();
    vehicleLicenseNumberController.dispose();
    insuranceNumberController.dispose();
    birthCertificateController.dispose();
    super.dispose();
  }
}
