import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/api/api_client.dart';
import 'package:taxify_driver_ui/api/services/my_rides_service.dart';
import 'package:taxify_driver_ui/api/enums/assignment_status_enum.dart';

class MyRidesProvider extends ChangeNotifier {
  int selectedIndex = 0;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  List<DriverStudentAssignment> parentRequestedAssignments = [];
  List<DriverStudentAssignment> completedAssignments = [];
  List<DriverStudentAssignment> cancelledAssignments = [];

  /// Initialize and fetch data on screen load
  Future<void> onInit() async {
    await fetchAssignmentsByStatus(AssignmentStatus.parentRequested);
  }

  /// Fetch assignments by status
  Future<void> fetchAssignmentsByStatus(AssignmentStatus status) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final myRidesService = MyRidesService(ApiClient());

      final response = await myRidesService.getDriverStudentAssignments(
        assignmentStatus: status.value,
      );

      if (response.success) {
        // Store data based on status
        switch (status) {
          case AssignmentStatus.parentRequested:
            parentRequestedAssignments = response.data;
            break;
          case AssignmentStatus.active:
            completedAssignments = response.data;
            break;
          case AssignmentStatus.rejected:
            cancelledAssignments = response.data;
            break;
          default:
            parentRequestedAssignments = response.data;
        }
        successMessage = '${status.value} assignments loaded successfully';
        errorMessage = null;
      } else {
        errorMessage =
            response.message ?? 'Failed to fetch ${status.value} assignments';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Get current list based on selected tab
  List<DriverStudentAssignment> getCurrentTabData() {
    switch (selectedIndex) {
      case 0:
        return parentRequestedAssignments;
      case 1:
        return completedAssignments;
      case 2:
        return cancelledAssignments;
      default:
        return parentRequestedAssignments;
    }
  }

  /// Update selected tab and fetch corresponding data
  Future<void> updateTab(int newIndex) async {
    selectedIndex = newIndex;
    notifyListeners();

    switch (newIndex) {
      case 0:
        await fetchAssignmentsByStatus(AssignmentStatus.parentRequested);
        break;
      case 1:
        await fetchAssignmentsByStatus(AssignmentStatus.active);
        break;
      case 2:
        await fetchAssignmentsByStatus(AssignmentStatus.rejected);
        break;
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a message
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show a message
      throw Exception('Location permissions are permanently denied.');
    }

    // When permissions are granted, get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
