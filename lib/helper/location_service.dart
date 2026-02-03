import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service to handle user location operations
class LocationService {
  /// Get current user location
  /// Returns LatLng if successful, null if permission denied or error occurs
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Open app settings to enable location
  static Future<void> openLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Open location service settings
  static Future<void> openLocationServiceSettings() async {
    await Geolocator.openLocationSettings();
  }
}
