import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/services/document_update_service.dart';
import 'package:taxify_driver_ui/api/models/documents/driver_documents_request.dart';

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
        originalInsuranceNumber != insuranceNumberController.text;
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

      final request = DriverDocumentsRequest(
        drivingLicenseNumber: drivingLicenseController.text,
        drivingLicensePhotoUrl: drivingLicensePhotoUrl ?? '',
        vehicleLicenseNumber: vehicleLicenseNumberController.text,
        vehicleLicensePhotoUrl: vehicleLicensePhotoUrl ?? '',
        insuranceNumber: insuranceNumberController.text,
        insurancePhotoUrl: insurancePhotoUrl ?? '',
      );

      final response =
          await documentUpdateService.updateDriverDocuments(request);

      if (response['success'] == true) {
        successMessage =
            response['message'] ?? 'Documents updated successfully';

        // Update original values after successful save
        originalDrivingLicense = drivingLicenseController.text;
        originalVehicleLicenseNumber = vehicleLicenseNumberController.text;
        originalInsuranceNumber = insuranceNumberController.text;

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
}
