import 'package:skolo_driver/config/environment.dart';

/// API Endpoints configuration
/// All endpoints are dynamically built using the environment-specific base URL
class Endpoints {
  /// Get the base URL for the current environment
  // static String get baseUrl => appConfig.baseUrl;
  static String get baseUrl => 'http://192.168.0.126:3000/api';

// ===== Authentication Endpoints =====
static String get sendOtp => '$baseUrl/auth/login/send-otp';
static String get verifyOtp => '$baseUrl/auth/login/verify-otp';
static String get registerSendOtp => '$baseUrl/auth/register/send-otp';
static String get registerVerifyOtp => '$baseUrl/auth/register/verify-otp';
static String get verifyToken => '$baseUrl/auth/verify-token';

// ===== Driver Endpoints =====
static String get driverProfile => '$baseUrl/driver/profile';
static String get updateDriverProfile => '$baseUrl/driver/profile';
static String get driverAvailability => '$baseUrl/driver/availability';
static String get driverDocuments => '$baseUrl/driver/documents';

// ===== Driver-Student Assignment Endpoints =====
static String get driverStudentAssignments =>
    '$baseUrl/driver/assignments/parent-requested';

// ===== Trip Endpoints =====
static String get createTrip => '$baseUrl/driver/trips';
static String get myTrips => '$baseUrl/driver/trips';
static String myTripsByDate(String date) =>
    '$baseUrl/driver/trips/by-date?date=$date';
static String updateTripStatus(String tripId) =>
    '$baseUrl/driver/trips/$tripId/status';

// ===== Tracking Endpoints =====
static String get trackingTomTom => '$baseUrl/driver/tracking/tomtom';
static String updateDriverPosition(String tripId) =>
    '$baseUrl/driver/tracking/$tripId/position';

// ===== Trip Students Endpoints =====
static String pickupPoint(String tripId) =>
    '$baseUrl/driver/trip-students/trip/$tripId/pickup-point';
static String schoolPoint(String tripId) =>
    '$baseUrl/driver/trip-students/trip/$tripId/school-point';
static String tripStudentsGroupedByParent(String tripId) =>
    '$baseUrl/driver/trip-students/trip/$tripId/grouped-by-parent';

// ===== Trip Progress Endpoints =====
static String tripProgress(String tripId) =>
    '$baseUrl/driver/trips/$tripId/progress';

// ===== Daily QR OTP Endpoints =====
static String get verifyDailyQrOtp => '$baseUrl/driver/qr-otp/verify';
}
