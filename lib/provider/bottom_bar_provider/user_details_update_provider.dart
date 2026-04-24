import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/api/api_client.dart';
import 'package:skolo_driver/api/models/user_details/user_details_update_request.dart';
import 'package:skolo_driver/api/services/user_details_service.dart';

class UserDetailsUpdateProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleCapacityController = TextEditingController();

  // Text Controllers for document verification
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController vehicleLicenseNumberController =
      TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();

  int selectedIndex = 0;
  bool isAvailable = false;
  bool isLoading = false;
  bool isUpdating = false;
  String? errorMessage;
  String? successMessage;

  // Store original values to check if changed
  String originalName = '';
  String originalEmail = '';
  String originalPhotoUrl = '';
  String originalVehicleNumber = '';
  int originalVehicleCapacity = 0;
  int originalSelectedIndex = 0;

  // Map to store images for each document type
  Map<String, File?> documentImages = {};

  // Getter for backward compatibility
  File? get image => documentImages['default'];

  List vehicles = [
    {
      'name': appFonts.auto,
      'image': 'assets/image/auth/auto.png',
      'value': 'auto'
    },
    {
      'name': appFonts.van,
      'image': 'assets/image/auth/van.png',
      'value': 'van'
    },
    {'name': appFonts.bus, 'image': 'assets/image/auth/bus.png', 'value': 'bus'}
  ];

  onInit() {
    fetchAndPopulateProfile();
  }

  /// Get vehicle index by type
  int getVehicleIndexByType(String vehicleType) {
    final index = vehicles.indexWhere(
      (vehicle) =>
          vehicle['value'].toString().toLowerCase() ==
          vehicleType.toLowerCase(),
    );
    return index >= 0 ? index : 1; // Default to van if not found
  }

  /// Check if any form values changed
  bool hasChanges() {
    return originalName != nameController.text ||
        originalEmail != emailController.text ||
        image != null ||
        originalVehicleNumber != vehicleNumberController.text ||
        originalVehicleCapacity !=
            int.tryParse(vehicleCapacityController.text) ||
        originalSelectedIndex != selectedIndex;
  }

  /// Fetch driver profile and populate form fields
  Future<void> fetchAndPopulateProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userDetailsService = UserDetailsService(ApiClient());
      final response = await userDetailsService.getDriverProfile();

      if (response.success) {
        final data = response.data;
        // Populate form fields
        nameController.text = data.name;
        emailController.text = data.email;
        phoneNumberController.text = data.phoneNumber;
        vehicleNumberController.text = data.vehicleNumber;
        vehicleCapacityController.text = data.vehicleCapacity.toString();

        // Set vehicle type index based on API response
        selectedIndex = getVehicleIndexByType(data.vehicleType);

        // Store original values
        originalName = data.name;
        originalEmail = data.email;
        originalPhotoUrl = data.photoUrl ?? '';
        originalVehicleNumber = data.vehicleNumber;
        originalVehicleCapacity = data.vehicleCapacity;
        originalSelectedIndex = selectedIndex;

        // Reset selected profile image after fresh fetch
        documentImages['default'] = null;

        isAvailable = data.isAvailable;
        errorMessage = null;
      } else {
        errorMessage = response.message ?? 'Failed to load profile';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Update driver profile
  Future<bool> updateDriverProfile() async {
    // Check if any changes were made
    if (!hasChanges()) {
      successMessage = 'No changes made';
      return true; // Return true but don't call API
    }

    isUpdating = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final userDetailsService = UserDetailsService(ApiClient());

      String? photoUrlForUpdate;
      if (image != null) {
        final existingPhotoUrl = originalPhotoUrl.trim();
        final uploadResponse = await userDetailsService.uploadSharedFile(
          file: image!,
          folderPath: 'profile/driver',
          oldFileUrl: existingPhotoUrl.isNotEmpty ? existingPhotoUrl : null,
        );

        if (uploadResponse['success'] != true) {
          errorMessage = uploadResponse['message'] ?? 'Failed to upload image';
          isUpdating = false;
          notifyListeners();
          return false;
        }

        photoUrlForUpdate = uploadResponse['url']?.toString();
      }

      final request = UserDetailsUpdateRequest(
        name: nameController.text,
        email: emailController.text,
        photoUrl: photoUrlForUpdate,
        vehicleType: vehicles[selectedIndex]['value'].toString(),
        vehicleNumber: vehicleNumberController.text,
        vehicleCapacity: int.tryParse(vehicleCapacityController.text) ?? 0,
        isAvailable: false,
      );

      final response = await userDetailsService.updateDriverProfile(request);

      if (response['success'] == true) {
        successMessage = response['message'] ?? 'Profile updated successfully';

        // Update original values after successful save
        originalName = nameController.text;
        originalEmail = emailController.text;
        if (photoUrlForUpdate != null && photoUrlForUpdate.isNotEmpty) {
          originalPhotoUrl = photoUrlForUpdate;
          documentImages['default'] = null;
        }
        originalVehicleNumber = vehicleNumberController.text;
        originalVehicleCapacity =
            int.tryParse(vehicleCapacityController.text) ?? 0;
        originalSelectedIndex = selectedIndex;

        isUpdating = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response['message'] ?? 'Failed to update profile';
        isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Pick image for document upload
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
                        onTap: () async {
                          route.pop(context);
                          await _performImagePick(
                              ImageSource.gallery, documentName);
                        }),
                    ListTile(
                        leading:
                            Icon(Icons.camera_alt, color: appTheme.primary),
                        title: Text(language(context, appFonts.openCamera),
                            style: AppCss.lexendMedium16
                                .textColor(appTheme.primary)),
                        onTap: () async {
                          route.pop(context);
                          await _performImagePick(
                              ImageSource.camera, documentName);
                        })
                  ])));
        });
  }

  /// Helper method to perform image picking from gallery or camera
  Future<void> _performImagePick(
      ImageSource source, String? documentName) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final key = documentName ?? 'default';
      documentImages[key] = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// Public source picker for screens that own their custom UI dialog.
  Future<void> pickImageFromSource(
    ImageSource source, {
    String? documentName,
  }) async {
    await _performImagePick(source, documentName);
  }
}
