import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service to handle user location operations
class LocationService {
  /// Cache last known location for background use
  static LatLng? _lastKnownLocation;

  /// Get current user location
  /// Returns LatLng if successful, null if permission denied or error occurs
  /// In background, may use last known location as fallback
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _lastKnownLocation;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _lastKnownLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _lastKnownLocation;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      ).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          return Geolocator.getLastKnownPosition().then((pos) {
            if (pos != null) {
              return pos;
            }
            throw Exception('No location available');
          });
        },
      );

      _lastKnownLocation = LatLng(position.latitude, position.longitude);
      return _lastKnownLocation;
    } catch (e) {
      return _lastKnownLocation;
    }
  }

  /// Get continuous location stream (battery-efficient)
  /// Emits position updates when device moves more than [distanceFilter] meters
  /// or every [timeLimit] seconds, whichever comes first
  /// This is more efficient than polling for foreground tracking
  static Stream<Position> getLocationStream({
    int distanceFilter = 15, // Emit on 15m movement
    Duration timeLimit = const Duration(seconds: 30),
  }) {
    _ensureLocationPermission();
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
        timeLimit: timeLimit,
      ),
    );
  }

  /// Get location stream for DISTANCE-BASED updates only
  /// Emits ONLY when device moves more than [distanceFilter] meters
  /// No time limit - only movement triggers updates
  static Stream<Position> getLocationStreamForDistance({
    int distanceFilter = 15, // Emit on 15m movement
  }) {
    _ensureLocationPermission();
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Ensure location permission before starting stream
  static Future<void> _ensureLocationPermission() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Request location permission with "Always Allow" for background tracking
  static Future<bool> requestLocationPermission({
    bool allowAlways = false,
  }) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // For background tracking, request "Always Allow"
      if (allowAlways && permission == LocationPermission.whileInUse) {
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

  /// Format distance value
  /// Returns formatted string like "50m" or "2.5km"
  static String formatDistance(double? distance) {
    if (distance == null) return '--';
    return distance < 1.0
        ? '${(distance * 1000).toStringAsFixed(0)}m'
        : '${distance.toStringAsFixed(2)}km';
  }

  /// Format duration in seconds to minutes
  /// Returns formatted string like "5min"
  static String formatDuration(int? duration) {
    if (duration == null) return '--';
    final minutes = (duration / 60).toStringAsFixed(0);
    return '${minutes}min';
  }

  /// Format estimated arrival time
  /// Returns formatted string like "14:30"
  static String formatETA(DateTime? eta) {
    if (eta == null) return '--';
    return '${eta.hour}:${eta.minute.toString().padLeft(2, '0')}';
  }
}
