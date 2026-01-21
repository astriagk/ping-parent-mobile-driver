/// API Endpoints configuration
class Endpoints {
  // Base URL - Change this to your API server
  static const String baseUrl =
      'https://ping-parent-backend-m8yc.onrender.com/api';

  // ===== Authentication Endpoints =====
  static const String sendOtp = '$baseUrl/auth/login/send-otp';
  static const String verifyOtp = '$baseUrl/auth/login/verify-otp';
  static const String registerSendOtp = '$baseUrl/auth/register/send-otp';
  static const String registerVerifyOtp = '$baseUrl/auth/register/verify-otp';
  static const String verifyToken = '$baseUrl/auth/verify-token';

  // ===== Profile Endpoints =====
  static const String parentProfile = '$baseUrl/parent/profile';
  static const String updateProfile = '$baseUrl/parent/profile/update';

  // ===== Driver Endpoints =====
  static const String driverList = '$baseUrl/driver/list';
  static const String assignDriver = '$baseUrl/driver/assign';

  // ===== Student Endpoints =====
  static const String studentList = '$baseUrl/student/list';
  static const String addStudent = '$baseUrl/student/add';
  static const String updateStudent = '$baseUrl/student/update';

  // ===== Other Endpoints =====
  static const String notificationList = '$baseUrl/notifications/list';
  static const String subscriptionPlans = '$baseUrl/subscriptions/plans';
}
