# Complete Authentication Flow - Implementation Guide

**Sign In → Sign Up → OTP Verification → Profile Check → Dashboard Navigation**

Complete, copy-paste ready code with state management and API integration.

---

## 📋 Overview

This document provides the complete authentication flow implementation with:

- ✅ Sign In screen (phone input)
- ✅ Sign Up screen (phone input + name)
- ✅ OTP verification (6-digit OTP)
- ✅ Profile checking (if profile exists → Dashboard, else → Complete Profile)
- ✅ State management (Provider pattern)
- ✅ API integration with auto-auth token injection

---

## 🏗️ Architecture Summary

```
Sign In/Sign Up Screen
    ↓
User enters phone → Provider.sendOtp()
    ↓
AuthService.sendOtp() → ApiClient.post(/auth/login/send-otp)
    ↓
OTP Screen
    ↓
User enters OTP → Provider.verifyOtp()
    ↓
AuthService.verifyOtp() → ApiClient.post(/auth/login/verify-otp)
    ↓
Token saved in StorageService (secure storage)
    ↓
Check Profile → UserService.getProfile()
    ↓
if (profile exists) → Navigate to Dashboard
else → Navigate to Complete Profile Screen
```

---

## 1️⃣ API Models (lib/api/models/)

### send_otp_response.dart

```dart
class SendOtpResponse {
  final bool success;
  final String? message;
  final String? error;

  SendOtpResponse({
    required this.success,
    this.message,
    this.error,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
    );
  }
}
```

### verify_otp_response.dart

```dart
class VerifyOtpResponse {
  final bool success;
  final String? message;
  final String? error;
  final String? token;
  final Map<String, dynamic>? user;

  VerifyOtpResponse({
    required this.success,
    this.message,
    this.error,
    this.token,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
      token: json['data'] != null ? json['data']['token'] : null,
      user: json['data'] != null ? json['data']['user'] : null,
    );
  }
}
```

### profile_response.dart

```dart
class ProfileResponse {
  final bool success;
  final ProfileData? data;
  final String message;

  ProfileResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class ProfileData {
  final String userId;
  final String name;
  final String email;
  final String? photoUrl;

  ProfileData({
    required this.userId,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
    );
  }
}
```

### verify_token_response.dart

```dart
class VerifyTokenResponse {
  final bool success;
  final String? message;
  final bool isAuthenticated;

  VerifyTokenResponse({
    required this.success,
    this.message,
    required this.isAuthenticated,
  });

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTokenResponse(
      success: json['success'] ?? false,
      message: json['message'],
      isAuthenticated: json['success'] ?? false,
    );
  }
}
```

---

## 2️⃣ API Endpoints (lib/api/endpoints.dart)

```dart
class Endpoints {
  static const String baseUrl = 'https://your-api.com/api';

  // Auth Endpoints
  static const String sendOtp = '$baseUrl/auth/login/send-otp';
  static const String verifyOtp = '$baseUrl/auth/login/verify-otp';
  static const String registerSendOtp = '$baseUrl/auth/register/send-otp';
  static const String registerVerifyOtp = '$baseUrl/auth/register/verify-otp';
  static const String verifyToken = '$baseUrl/auth/verify-token';

  // Profile Endpoints
  static const String parentProfile = '$baseUrl/parent/profile';
}
```

---

## 3️⃣ Storage Service (lib/api/services/storage_service.dart)

**Singleton Pattern - One instance throughout app**

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Storage Keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // ===== SECURE STORAGE (Encrypted) =====

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _keyAuthToken, value: token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _keyAuthToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _keyUserId);
  }

  /// Save user phone
  Future<void> saveUserPhone(String phone) async {
    await _secureStorage.write(key: _keyUserPhone, value: phone);
  }

  /// Get user phone
  Future<String?> getUserPhone() async {
    return await _secureStorage.read(key: _keyUserPhone);
  }

  /// Save user name
  Future<void> saveUserName(String name) async {
    await _secureStorage.write(key: _keyUserName, value: name);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: _keyUserEmail, value: email);
  }

  // ===== PREFERENCES (Non-sensitive) =====

  /// Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  /// Check if logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout - Clear all data
  Future<void> logout() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Check if token exists and is valid
  Future<bool> hasValidSession() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
```

---

## 4️⃣ API Client (lib/api/api_client.dart)

**Automatic Auth Token Injection**

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/storage_service.dart';

class ApiClient {
  final http.Client _client;
  final StorageService _storage = StorageService();

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Get headers with authentication token
  Future<Map<String, String>> getHeaders(
      {Map<String, String>? additionalHeaders}) async {
    final token = await _storage.getAuthToken(); // ⭐ Auto-read token
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // ⭐ Auto-inject
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<http.Response> get(String url,
      {Map<String, String>? headers}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.get(Uri.parse(url), headers: requestHeaders);
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.post(
      Uri.parse(url),
      headers: requestHeaders,
      body: body is Map ? json.encode(body) : body,
    );
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, Object? body}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.put(
      Uri.parse(url),
      headers: requestHeaders,
      body: body is Map ? json.encode(body) : body,
    );
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    final requestHeaders = await getHeaders(additionalHeaders: headers);
    return await _client.delete(Uri.parse(url), headers: requestHeaders);
  }
}
```

---

## 5️⃣ Auth Service (lib/api/services/auth_service.dart)

**Handles all authentication logic**

```dart
import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import '../models/verify_token_response.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _apiClient;
  final StorageService _storage = StorageService();

  AuthService(this._apiClient);

  /// Send OTP for sign in (phone login)
  Future<SendOtpResponse> sendOtp({required String phone}) async {
    try {
      final response = await _apiClient.post(
        Endpoints.sendOtp,
        body: jsonEncode({'phone': phone}),
      );
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Network error. Please try again.',
      );
    }
  }

  /// Verify OTP and get token (sign in)
  Future<VerifyOtpResponse> verifyOtp(
      {required String phone, required String otp}) async {
    try {
      final response = await _apiClient.post(
        Endpoints.verifyOtp,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final verifyResponse =
          VerifyOtpResponse.fromJson(jsonDecode(response.body));

      // ⭐ CRITICAL: Save session immediately after successful verification
      if (response.statusCode == 200 && verifyResponse.success) {
        await _saveUserSession(verifyResponse, phone);
      }

      return verifyResponse;
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        error: 'Network error. Please try again.',
      );
    }
  }

  /// Send OTP for sign up (new user registration)
  Future<SendOtpResponse> registerSendOtp({required String phone}) async {
    try {
      final response = await _apiClient.post(
        Endpoints.registerSendOtp,
        body: jsonEncode({'phone': phone}),
      );
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return SendOtpResponse(
        success: false,
        error: 'Network error. Please try again.',
      );
    }
  }

  /// Verify OTP for sign up (new user registration)
  Future<VerifyOtpResponse> registerVerifyOtp(
      {required String phone, required String otp}) async {
    try {
      final response = await _apiClient.post(
        Endpoints.registerVerifyOtp,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final verifyResponse =
          VerifyOtpResponse.fromJson(jsonDecode(response.body));

      // ⭐ CRITICAL: Save session immediately after successful registration
      if (response.statusCode == 200 && verifyResponse.success) {
        await _saveUserSession(verifyResponse, phone);
      }

      return verifyResponse;
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        error: 'Network error. Please try again.',
      );
    }
  }

  /// Verify token validity
  Future<VerifyTokenResponse> verifyToken() async {
    try {
      final response = await _apiClient.get(Endpoints.verifyToken);
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return VerifyTokenResponse(
        success: false,
        isAuthenticated: false,
      );
    }
  }

  /// ⭐ Save user session after successful authentication
  Future<void> _saveUserSession(
      VerifyOtpResponse response, String phone) async {
    if (response.token != null) {
      // Save token (used in all future requests)
      await _storage.saveAuthToken(response.token!);
      await _storage.saveUserPhone(phone);
      await _storage.saveLoginStatus(true);
    }

    // Save user data
    if (response.user != null) {
      final userData = response.user!;
      if (userData['id'] != null) {
        await _storage.saveUserId(userData['id'].toString());
      }
      if (userData['name'] != null) {
        await _storage.saveUserName(userData['name'].toString());
      }
      if (userData['email'] != null) {
        await _storage.saveUserEmail(userData['email'].toString());
      }
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storage.logout();
  }

  /// Check if user has valid session
  Future<bool> hasValidSession() async {
    return await _storage.hasValidSession();
  }
}
```

---

## 6️⃣ User Service (lib/api/services/user_service.dart)

**Fetch user profile**

```dart
import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../models/profile_response.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  /// Get parent profile
  Future<ProfileResponse> getParentProfile() async {
    try {
      final response = await _apiClient.get(Endpoints.parentProfile);
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ProfileResponse(
        success: false,
        message: 'Failed to load profile',
      );
    }
  }
}
```

---

## 7️⃣ Providers (lib/provider/auth_providers/)

### auth_provider.dart - Main Authentication Provider

```dart
import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/auth_service.dart';
import '../../api/services/user_service.dart';
import '../../api/models/profile_response.dart';

class AuthProvider extends ChangeNotifier {
  // ===== SIGN IN / SIGN UP STATE =====
  String? currentPhone; // Store phone during OTP flow
  bool isSignIn = true; // true: sign in, false: sign up

  // ===== SEND OTP STATE =====
  bool isSendingOtp = false;
  String? sendOtpError;

  // ===== VERIFY OTP STATE =====
  bool isVerifyingOtp = false;
  String? verifyOtpError;

  // ===== PROFILE CHECK STATE =====
  bool isCheckingProfile = false;
  ProfileData? userProfile;
  String? profileCheckError;

  // ===== FORM CONTROLLERS =====
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  /// Switch between Sign In and Sign Up
  void toggleAuthMode(bool isSignIn) {
    this.isSignIn = isSignIn;
    clearErrors();
    notifyListeners();
  }

  /// Clear all errors
  void clearErrors() {
    sendOtpError = null;
    verifyOtpError = null;
    profileCheckError = null;
    notifyListeners();
  }

  // ===== SEND OTP =====
  Future<bool> sendOtp() async {
    final phone = phoneController.text.trim();

    // Validation
    if (phone.isEmpty) {
      sendOtpError = 'Please enter your phone number';
      notifyListeners();
      return false;
    }

    if (phone.length < 10) {
      sendOtpError = 'Please enter a valid phone number';
      notifyListeners();
      return false;
    }

    isSendingOtp = true;
    sendOtpError = null;
    notifyListeners();

    try {
      final authService = AuthService(ApiClient());

      // Choose send OTP endpoint based on mode
      late SendOtpResponse response;
      if (isSignIn) {
        response = await authService.sendOtp(phone: phone);
      } else {
        response = await authService.registerSendOtp(phone: phone);
      }

      if (response.success) {
        currentPhone = phone; // Store phone for OTP verification
        isSendingOtp = false;
        sendOtpError = null;
        notifyListeners();
        return true;
      } else {
        sendOtpError = response.message ?? response.error ?? 'Failed to send OTP';
        isSendingOtp = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      sendOtpError = 'An error occurred. Please try again.';
      isSendingOtp = false;
      notifyListeners();
      return false;
    }
  }

  // ===== VERIFY OTP =====
  Future<bool> verifyOtp() async {
    final otp = otpController.text.trim();
    final phone = currentPhone;

    // Validation
    if (phone == null || phone.isEmpty) {
      verifyOtpError = 'Phone number not found. Please try again.';
      notifyListeners();
      return false;
    }

    if (otp.isEmpty) {
      verifyOtpError = 'Please enter the OTP';
      notifyListeners();
      return false;
    }

    if (otp.length != 6) {
      verifyOtpError = 'OTP must be 6 digits';
      notifyListeners();
      return false;
    }

    isVerifyingOtp = true;
    verifyOtpError = null;
    notifyListeners();

    try {
      final authService = AuthService(ApiClient());

      // Choose verify OTP endpoint based on mode
      late VerifyOtpResponse response;
      if (isSignIn) {
        response = await authService.verifyOtp(phone: phone, otp: otp);
      } else {
        response = await authService.registerVerifyOtp(phone: phone, otp: otp);
      }

      if (response.success) {
        // ⭐ Token is now saved by AuthService._saveUserSession()
        // Now check if profile exists
        isVerifyingOtp = false;
        verifyOtpError = null;
        notifyListeners();

        // Move to profile check
        await checkUserProfile();
        return true;
      } else {
        verifyOtpError = response.message ?? response.error ?? 'Invalid OTP';
        isVerifyingOtp = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      verifyOtpError = 'An error occurred. Please try again.';
      isVerifyingOtp = false;
      notifyListeners();
      return false;
    }
  }

  // ===== CHECK USER PROFILE =====
  Future<void> checkUserProfile() async {
    isCheckingProfile = true;
    profileCheckError = null;
    userProfile = null;
    notifyListeners();

    try {
      final userService = UserService(ApiClient());
      final response = await userService.getParentProfile();

      if (response.success && response.data != null) {
        // ✅ Profile exists
        userProfile = response.data;
        isCheckingProfile = false;
        notifyListeners();
        // Screen will navigate to Dashboard
      } else {
        // ❌ Profile doesn't exist
        // Screen will navigate to Complete Profile screen
        isCheckingProfile = false;
        notifyListeners();
      }
    } catch (e) {
      // Profile check failed, treat as no profile
      isCheckingProfile = false;
      userProfile = null;
      notifyListeners();
    }
  }

  // ===== LOGOUT =====
  Future<void> logout() async {
    final authService = AuthService(ApiClient());
    await authService.logout();

    // Clear local state
    phoneController.clear();
    nameController.clear();
    otpController.clear();
    currentPhone = null;
    userProfile = null;
    clearErrors();
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
```

---

## 8️⃣ Splash Screen (lib/screens/auth_screen/splash_screen.dart)

**Check if user is logged in, navigate accordingly**

```dart
import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/auth_service.dart';
import '../../routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Wait 2 seconds for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user has valid session
    final authService = AuthService(ApiClient());
    final hasValidSession = await authService.hasValidSession();

    if (hasValidSession) {
      // ✅ User is logged in → Go to Dashboard
      Navigator.of(context).pushReplacementNamed(RouteName().dashBoardLayout);
    } else {
      // ❌ User not logged in → Go to Sign In
      Navigator.of(context).pushReplacementNamed(RouteName().signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or branding
            Image.asset('assets/logo.png', width: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

---

## 9️⃣ Sign In / Sign Up Screen (lib/screens/auth_screen/signin_signup_screen.dart)

**Phone input screen**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_providers/auth_provider.dart';
import '../../routes/route_name.dart';

class SignInSignUpScreen extends StatelessWidget {
  const SignInSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(authProvider.isSignIn ? 'Sign In' : 'Sign Up'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    authProvider.isSignIn ? 'Welcome Back' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    authProvider.isSignIn
                        ? 'Enter your phone number to sign in'
                        : 'Enter your phone number to create a new account',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Phone Input
                  TextField(
                    controller: authProvider.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+1 ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: authProvider.sendOtpError,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Send OTP Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isSendingOtp
                          ? null
                          : () async {
                              final success = await authProvider.sendOtp();
                              if (success && context.mounted) {
                                // Navigate to OTP screen
                                Navigator.of(context).pushNamed(
                                  RouteName().otpScreen,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: authProvider.isSendingOtp
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Send OTP',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Toggle Sign In / Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authProvider.isSignIn
                            ? "Don't have an account? "
                            : 'Already have an account? ',
                        style: const TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          authProvider.toggleAuthMode(!authProvider.isSignIn);
                        },
                        child: Text(
                          authProvider.isSignIn ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 🔟 OTP Verification Screen (lib/screens/auth_screen/otp_screen.dart)

**OTP input screen with profile check**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_providers/auth_provider.dart';
import '../../routes/route_name.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verify OTP'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'We sent a 6-digit code to ${authProvider.currentPhone}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // OTP Input (you can use a package like pin_code_fields)
                  TextField(
                    controller: authProvider.otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '000000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: authProvider.verifyOtpError,
                      counterText: '', // Hide counter
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isVerifyingOtp ||
                              authProvider.isCheckingProfile
                          ? null
                          : () async {
                              final success = await authProvider.verifyOtp();
                              if (success && context.mounted) {
                                // Profile check happens in verifyOtp()
                                // Check if profile exists
                                if (authProvider.userProfile != null) {
                                  // ✅ Profile exists → Go to Dashboard
                                  Navigator.of(context)
                                      .pushReplacementNamed(
                                        RouteName().dashBoardLayout,
                                      );
                                } else {
                                  // ❌ Profile doesn't exist → Go to Complete Profile
                                  Navigator.of(context).pushReplacementNamed(
                                    RouteName().completeProfileScreen,
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          authProvider.isVerifyingOtp ||
                                  authProvider.isCheckingProfile
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Verify OTP',
                                  style: TextStyle(fontSize: 16),
                                ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resend OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive code? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          authProvider.sendOtp();
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## 1️⃣1️⃣ Register Providers (lib/main.dart)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ⭐ Register Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Add other providers here
      ],
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          RouteName().signInScreen: (context) => const SignInSignUpScreen(),
          RouteName().otpScreen: (context) => const OtpScreen(),
          RouteName().dashBoardLayout: (context) => const DashboardScreen(),
          RouteName().completeProfileScreen: (context) => const CompleteProfileScreen(),
        },
      ),
    );
  }
}
```

---

## 1️⃣2️⃣ Route Names (lib/routes/route_name.dart)

```dart
class RouteName {
  final String splash = '/';
  final String signInScreen = '/signInScreen';
  final String otpScreen = '/otpScreen';
  final String dashBoardLayout = '/dashBoardLayout';
  final String completeProfileScreen = '/completeProfileScreen';
}
```

---

## 📊 State Management Summary

### AuthProvider State

```
┌─────────────────────────────────────┐
│ AuthProvider (ChangeNotifier)       │
├─────────────────────────────────────┤
│ STATE:                              │
│ ├─ isSignIn (bool)                  │
│ ├─ currentPhone (String?)            │
│ ├─ isSendingOtp (bool)               │
│ ├─ sendOtpError (String?)            │
│ ├─ isVerifyingOtp (bool)             │
│ ├─ verifyOtpError (String?)          │
│ ├─ isCheckingProfile (bool)          │
│ ├─ userProfile (ProfileData?)        │
│ └─ profileCheckError (String?)       │
│                                     │
│ METHODS:                            │
│ ├─ toggleAuthMode()                 │
│ ├─ sendOtp()                        │
│ ├─ verifyOtp()                      │
│ ├─ checkUserProfile()               │
│ ├─ logout()                         │
│ └─ clearErrors()                    │
└─────────────────────────────────────┘
```

### Data Flow

```
User Input (Phone)
    ↓
AuthProvider.sendOtp()
    ↓ notifyListeners()
Screen shows isSendingOtp (loading)
    ↓
AuthService.sendOtp()
    ↓
ApiClient.post(/auth/login/send-otp)
    ↓
Backend (OTP sent)
    ↓
AuthProvider.sendOtp() returns success
    ↓ notifyListeners()
Screen navigates to OTP Screen
    ↓
User enters OTP
    ↓
AuthProvider.verifyOtp()
    ↓ notifyListeners()
Screen shows isVerifyingOtp (loading)
    ↓
AuthService.verifyOtp()
    ↓
ApiClient.post(/auth/login/verify-otp)
    ├─ Auth header: Authorization: Bearer <token> ✅ Auto-injected
    └─ Backend returns token
    ↓
AuthService._saveUserSession()
    ├─ StorageService.saveAuthToken(token)
    ├─ StorageService.saveUserId()
    └─ StorageService.saveLoginStatus()
    ↓
AuthProvider.checkUserProfile()
    ↓ notifyListeners()
Screen shows isCheckingProfile (loading)
    ↓
UserService.getParentProfile()
    ↓
ApiClient.get(/parent/profile)
    ├─ Auth header: Authorization: Bearer <token> ✅ Auto-injected from storage
    └─ Backend returns profile
    ↓
if (profile exists) {
    userProfile = profile
    Screen navigates to Dashboard ✅
} else {
    userProfile = null
    Screen navigates to Complete Profile ✅
}
```

---

## 🎯 Key Points

### 1. **Automatic Token Injection**

```dart
// In ApiClient.getHeaders()
final token = await _storage.getAuthToken();
if (token != null) {
  headers['Authorization'] = 'Bearer $token';
}

// Result: Every API call is authenticated automatically!
```

### 2. **Session Persistence**

```dart
// After OTP verification:
await _storage.saveAuthToken(token);
// Token now persists across app restarts
```

### 3. **Profile Check & Navigation**

```dart
// After OTP verification:
await checkUserProfile();

if (userProfile != null) {
  // Profile complete → Dashboard
} else {
  // Profile incomplete → Complete Profile
}
```

### 4. **State Management**

```dart
// Every action:
1. Update state variables
2. Call notifyListeners()
3. UI rebuilds automatically
```

---

## ✅ Checklist for Implementation

- [ ] Copy `StorageService` code
- [ ] Copy `ApiClient` code
- [ ] Copy response models
- [ ] Copy endpoints
- [ ] Copy `AuthService` code
- [ ] Copy `UserService` code
- [ ] Copy `AuthProvider` code
- [ ] Copy splash screen
- [ ] Copy sign in/sign up screen
- [ ] Copy OTP screen
- [ ] Register provider in `main.dart`
- [ ] Add routes to `route_name.dart`
- [ ] Configure routes in `main.dart`
- [ ] Create `CompleteProfileScreen` (for new users)
- [ ] Test the flow!

---

## 🚀 Quick Copy-Paste Structure

```
lib/
├── api/
│   ├── api_client.dart
│   ├── endpoints.dart
│   ├── models/
│   │   ├── send_otp_response.dart
│   │   ├── verify_otp_response.dart
│   │   ├── profile_response.dart
│   │   └── verify_token_response.dart
│   └── services/
│       ├── auth_service.dart
│       ├── storage_service.dart
│       └── user_service.dart
│
├── provider/
│   └── auth_providers/
│       └── auth_provider.dart
│
├── screens/
│   └── auth_screen/
│       ├── splash_screen.dart
│       ├── signin_signup_screen.dart
│       └── otp_screen.dart
│
├── routes/
│   └── route_name.dart
│
└── main.dart
```

---

## 🎓 What This Gives You

✅ Complete authentication flow (Sign In / Sign Up / OTP)
✅ Automatic token injection (no manual auth header management)
✅ Session persistence (user stays logged in after app restart)
✅ Profile checking (navigate to Dashboard or Complete Profile)
✅ Proper state management (Provider pattern with notifyListeners)
✅ Error handling (user-friendly error messages)
✅ Clean, scalable architecture

**Copy the code above and customize with your API endpoints and UI. Ready to use!**
