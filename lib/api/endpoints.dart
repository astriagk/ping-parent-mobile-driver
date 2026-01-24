import 'package:taxify_driver_ui/config/environment.dart';

/// API Endpoints configuration
/// All endpoints are dynamically built using the environment-specific base URL
class Endpoints {
  /// Get the base URL for the current environment
  static String get baseUrl => appConfig.baseUrl;

  // ===== Authentication Endpoints =====
  static String get sendOtp => '$baseUrl/auth/login/send-otp';
  static String get verifyOtp => '$baseUrl/auth/login/verify-otp';
  static String get registerSendOtp => '$baseUrl/auth/register/send-otp';
  static String get registerVerifyOtp => '$baseUrl/auth/register/verify-otp';
  static String get verifyToken => '$baseUrl/auth/verify-token';

  // ===== Driver Endpoints =====
  static String get driverProfile => '$baseUrl/driver/profile';
  static String get updateDriverProfile => '$baseUrl/driver/profile';
  static String get driverDocuments => '$baseUrl/driver/documents';
}
