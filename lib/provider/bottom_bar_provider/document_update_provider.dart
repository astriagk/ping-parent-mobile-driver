import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/data/datasources/remote/api_client.dart';
import 'package:skolo_driver/api/services/document_update_service.dart';

class DocumentUpdateProvider extends ChangeNotifier {
  // Text Controllers for document verification
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController vehicleLicenseNumberController =
      TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();

  bool isLoading = false;
  bool isUpdating = false;
  String? errorMessage;
  String? successMessage;

  // Store photo URLs from API
  String? drivingLicensePhotoUrl;
  String? vehicleLicensePhotoUrl;
  String? insurancePhotoUrl;


  // Store original values to check if changed
  String originalDrivingLicense = '';
  String originalVehicleLicenseNumber = '';
  String originalInsuranceNumber = '';

  // Map to store picked images for each document type
  Map<String, File?> documentImages = {};

  onInit() {
    fetchAndPopulateDocuments();
  }

  /// Check if any form values changed
  bool hasChanges() {
    return originalDrivingLicense != drivingLicenseController.text ||
        originalVehicleLicenseNumber != vehicleLicenseNumberController.text ||
        originalInsuranceNumber != insuranceNumberController.text ||
        _hasPhotoChanges();
  }

  /// True when user has picked/replaced any document image in this session.
  bool _hasPhotoChanges() {
    return documentImages.values.any((file) => file != null);
  }

  /// Fetch driver documents and populate form fields
  Future<void> fetchAndPopulateDocuments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final documentUpdateService = DocumentUpdateService(ApiClient());
      final response = await documentUpdateService.getDriverDocuments();

      if (response.success && response.data != null) {
        final data = response.data!;
        // Populate form fields
        drivingLicenseController.text = data.drivingLicenseNumber;
        vehicleLicenseNumberController.text = data.vehicleLicenseNumber;
        insuranceNumberController.text = data.insuranceNumber;

        // Store original values
        originalDrivingLicense = data.drivingLicenseNumber;
        originalVehicleLicenseNumber = data.vehicleLicenseNumber;
        originalInsuranceNumber = data.insuranceNumber;

        // Store photo URLs
        drivingLicensePhotoUrl = data.drivingLicensePhotoUrl;
        vehicleLicensePhotoUrl = data.vehicleLicensePhotoUrl;
        insurancePhotoUrl = data.insurancePhotoUrl;

        errorMessage = null;
      } else {
        errorMessage = response.message ?? 'Failed to load documents';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Update driver documents
  Future<bool> updateDriverDocuments() async {
    // Check if any changes were made
    if (!hasChanges()) {
      successMessage = 'No changes made';
      return true;
    }

    isUpdating = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    // Allow UI to update before API call
    await Future.delayed(Duration.zero);

    try {
      final documentUpdateService = DocumentUpdateService(ApiClient());

      final drivingLicenseImage = documentImages[appFonts.drivingLicense];
      final vehicleLicenseImage = documentImages[appFonts.vehicleLicenseNumber];
      final insuranceImage = documentImages[appFonts.insuranceNumber];

      final response = await documentUpdateService.updateDriverDocuments(
        drivingLicenseNumber: drivingLicenseController.text,
        vehicleLicenseNumber: vehicleLicenseNumberController.text,
        insuranceNumber: insuranceNumberController.text,
        drivingLicenseImage: drivingLicenseImage,
        vehicleLicenseImage: vehicleLicenseImage,
        insuranceImage: insuranceImage,
      );

      if (response['success'] == true) {
        successMessage =
            response['message'] ?? 'Documents updated successfully';

        // Update original values after successful save
        originalDrivingLicense = drivingLicenseController.text;
        originalVehicleLicenseNumber = vehicleLicenseNumberController.text;
        originalInsuranceNumber = insuranceNumberController.text;
        documentImages.clear();

        isUpdating = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response['message'] ?? 'Failed to update documents';
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

  @override
  void dispose() {
    drivingLicenseController.dispose();
    vehicleLicenseNumberController.dispose();
    insuranceNumberController.dispose();
    super.dispose();
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
                                      ? ' - ${language(context, documentName)}'
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
}
