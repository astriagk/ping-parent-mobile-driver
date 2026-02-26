import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/widgets/common_confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skolo_driver/api/services/active_ride_service.dart';
import 'package:skolo_driver/api/models/get_my_trips_response.dart';
import 'package:skolo_driver/api/enums/trip_type_enum.dart';
import 'package:skolo_driver/api/api_client.dart';

class ActiveRideProvider extends ChangeNotifier {
  late final ActiveRideService _activeRideService;

  bool isLoading = false;

  /// Track loading state per trip type for individual button loading
  TripType? loadingTripType;
  String? successMessage;
  String? errorMessage;
  List<TripData> myTrips = [];

  ActiveRideProvider() {
    _activeRideService = ActiveRideService(ApiClient());
  }

  /// Check if a specific trip type button is loading
  bool isLoadingForType(TripType tripType) => loadingTripType == tripType;

  cancelRideTap(context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
              message: "Are you sure you want to cancel your ride?",
              onConfirm: () => removeRide(index, context),
              onCancel: () => route.pop(context));
        });
  }

  void removeRide(int index, context) {
    appArray.ridesData.removeAt(index);
    route.pop(context);
    notifyListeners();
  }

  Future<void> openDialer(String phoneNumber) async {
    // Request phone permission
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      // Try to launch the dialer
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        log("Could not open dialer");
      }
    } else if (status.isDenied) {
      log("Phone permission denied");
    } else if (status.isPermanentlyDenied) {
      log("Phone permission permanently denied, open app settings.");
      openAppSettings();
    }
  }

  /// Create a new trip with the specified trip type and time
  /// Handles API call, error management, and message setting
  ///
  /// Parameters:
  ///   - tripType: Type of trip (TripType.pickup or TripType.drop)
  ///   - tripDate: DateTime object for the trip
  ///
  /// Returns:
  ///   - true if trip creation is successful, false otherwise
  Future<bool> createTrip({
    required TripType tripType,
    required DateTime tripDate,
  }) async {
    try {
      // Only set button loading, not skeleton loading
      loadingTripType = tripType;
      successMessage = null;
      errorMessage = null;
      notifyListeners();

      final response = await _activeRideService.createTrip(
        tripType: tripType,
        tripDate: tripDate,
      );

      if (response.success && response.data != null) {
        successMessage = response.message;
        loadingTripType = null;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message;
        loadingTripType = null;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error creating trip: ${e.toString()}';
      loadingTripType = null;
      notifyListeners();
      return false;
    }
  }

  /// Fetch list of trips for the current driver
  ///
  /// Returns:
  ///   - true if fetch is successful, false otherwise
  Future<bool> fetchMyTrips() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _activeRideService.getMyTrips();

      if (response.success) {
        myTrips = response.data;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error fetching trips: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch list of trips for the current driver by date
  ///
  /// Parameters:
  ///   - date: Optional DateTime to filter trips (defaults to current date)
  ///   - showLoading: Whether to show skeleton loading (set false for silent refresh)
  ///
  /// Returns:
  ///   - true if fetch is successful, false otherwise
  Future<bool> fetchMyTripsByDate(
      {DateTime? date, bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoading = true;
        notifyListeners();
      }
      errorMessage = null;

      final response = await _activeRideService.getMyTripsByDate(date: date);

      if (response.success) {
        myTrips = response.data;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error fetching trips: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
