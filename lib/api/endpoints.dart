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

  // ===== Profile Endpoints =====
  static String get parentProfile => '$baseUrl/parent/profile';
  static String get updateProfile => '$baseUrl/parent/profile/update';

  // ===== Driver Endpoints =====
  static String get driverList => '$baseUrl/driver/list';
  static String get assignDriver => '$baseUrl/driver/assign';

  // ===== Student Endpoints =====
  static String get studentList => '$baseUrl/student/list';
  static String get addStudent => '$baseUrl/student/add';
  static String get updateStudent => '$baseUrl/student/update';

  // ===== Other Endpoints =====
  static String get notificationList => '$baseUrl/notifications/list';
  static String get subscriptionPlans => '$baseUrl/subscriptions/plans';
}
