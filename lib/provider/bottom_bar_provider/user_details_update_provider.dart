import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/models/user_details_update_request.dart';
import 'package:taxify_driver_ui/api/services/user_details_service.dart';

class UserDetailsUpdateProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleCapacityController = TextEditingController();

  int selectedIndex = 0;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // Store original values to check if changed
  String originalName = '';
  String originalEmail = '';
  String originalVehicleNumber = '';
  int originalVehicleCapacity = 0;
  int originalSelectedIndex = 0;

  List vehicles = [
    {
      'name': appFonts.auto,
      'image': 'assets/image/auth/van.png',
      'value': 'auto'
    },
    {
      'name': appFonts.van,
      'image': 'assets/image/auth/van.png',
      'value': 'van'
    },
    {'name': appFonts.bus, 'image': 'assets/image/auth/van.png', 'value': 'bus'}
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
        vehicleNumberController.text = data.vehicleNumber;
        vehicleCapacityController.text = data.vehicleCapacity.toString();

        // Set vehicle type index based on API response
        selectedIndex = getVehicleIndexByType(data.vehicleType);

        // Store original values
        originalName = data.name;
        originalEmail = data.email;
        originalVehicleNumber = data.vehicleNumber;
        originalVehicleCapacity = data.vehicleCapacity;
        originalSelectedIndex = selectedIndex;

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

    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final userDetailsService = UserDetailsService(ApiClient());

      final request = UserDetailsUpdateRequest(
        name: nameController.text,
        email: emailController.text,
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
        originalVehicleNumber = vehicleNumberController.text;
        originalVehicleCapacity =
            int.tryParse(vehicleCapacityController.text) ?? 0;
        originalSelectedIndex = selectedIndex;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response['message'] ?? 'Failed to update profile';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
