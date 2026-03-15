/// App-wide constants
class AppConstants {
  static const String schoolLocationType = 'SCHOOL_LOCATION';

  // ===== Location Tracking Settings =====

  // Socket emit interval (time-based)
  // Emits position via socket every 10 seconds regardless of movement
  static const Duration socketEmitInterval = Duration(seconds: 10);

  // API update distance filter (distance-based)
  // Sends API call ONLY when device moves more than 200 meters
  static const int apiUpdateDistanceFilter = 200; // meters

  // Background GPS stream distance filter (meters)
  // Minimum movement before the GPS stream emits a new position in background
  static const int backgroundDistanceFilter = 0; // 10; // meters

  // ===== Navigation Map Rotation Settings =====

  // Minimum speed (m/s) before map heading updates (~7.2 km/h)
  // Prevents map rotation from GPS drift while stationary
  static const double navigationSpeedThreshold = 2.0;

  // Minimum heading change (degrees) before map rotates
  // Prevents micro-rotations from GPS noise
  static const double navigationHeadingThreshold = 10.0;

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
