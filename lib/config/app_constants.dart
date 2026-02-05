/// App-wide constants
class AppConstants {
  static const String schoolLocationType = 'SCHOOL_LOCATION';

  // ===== Location Tracking Settings =====

  // Socket emit interval (time-based)
  // Emits position via socket every 10 seconds regardless of movement
  static const Duration socketEmitInterval = Duration(seconds: 10);

  // API update distance filter (distance-based)
  // Sends API call ONLY when device moves more than 100 meters
  static const int apiUpdateDistanceFilter = 100; // meters

  // Distance filter for location stream (meters)
  // Used for real-time UI updates - more frequent than API updates
  static const int locationStreamDistanceFilter = 15; // meters

  // Time limit for location stream (seconds)
  // Emits location update at least once per this duration
  static const Duration locationStreamTimeLimit = Duration(seconds: 30);

  // Background service location update interval
  // Polling interval when using background service
  static const Duration backgroundLocationUpdateInterval =
      Duration(seconds: 10);
}
