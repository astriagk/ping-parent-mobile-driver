/// API REFERENCE DOCUMENTATION
/// 
/// Endpoint Details for Sign In Flow
/// ================================
/// 
/// API: /auth/login/send-otp
/// Method: POST
/// Base URL: https://your-api-server.com/api
/// Full URL: https://your-api-server.com/api/auth/login/send-otp
/// 
/// REQUEST PAYLOAD
/// ===============
/// {
///   "phone": "8867347448"
/// }
/// 
/// REQUEST HEADERS
/// ===============
/// Content-Type: application/json
/// Accept: application/json
/// Authorization: (NOT REQUIRED for sign in, only added if token exists)
/// 
/// RESPONSE (Success)
/// ==================
/// Status: 200 or 201
/// {
///   "success": true,
///   "message": "Login OTP sent to phone number"
/// }
/// 
/// RESPONSE (Error)
/// ================
/// Status: 400, 401, 500, etc.
/// {
///   "success": false,
///   "error": "Phone number not found" // or any error message
/// }
/// 
/// CODE FLOW
/// =========
/// 1. User enters phone number in SignInScreen
/// 2. User taps "Get OTP" button
/// 3. SignInProvider.sendOtp() is called
/// 4. AuthService.sendOtp() is called
/// 5. ApiClient.post() sends request to /auth/login/send-otp
/// 6. Backend validates phone and sends OTP via SMS
/// 7. Response is parsed as SendOtpResponse
/// 8. If success → Navigate to OTP screen
/// 9. If error → Show error message to user
/// 
/// ERROR HANDLING
/// ==============
/// - Network error → Catch block → sendOtpError = "Error: ..."
/// - Invalid response → Status code check → sendOtpError = response.error
/// - Missing phone → Validation → sendOtpError = "Please enter a phone number"
/// 
/// IMPLEMENTATION FILES
/// ====================
/// Request Model: lib/api/models/send_otp_request.dart
/// Response Model: lib/api/models/send_otp_response.dart
/// API Endpoints: lib/api/endpoints.dart
/// API Client: lib/api/api_client.dart
/// Storage Service: lib/api/services/storage_service.dart
/// Auth Service: lib/api/services/auth_service.dart
/// Provider: lib/provider/auth_providers/sign_in_provider.dart
/// Screen: lib/screens/auth_screen/sign_in_screen/sign_in_screen.dart
/// 
/// TESTING
/// =======
/// To test locally, update Endpoints.baseUrl to your test server:
/// 
/// static const String baseUrl = 'http://localhost:3000/api';
/// 
/// Or use a mock API tool like:
/// - Postman
/// - Thunder Client
/// - httpie
/// 
/// Example request:
/// curl -X POST https://your-api-server.com/api/auth/login/send-otp \
///   -H "Content-Type: application/json" \
///   -d '{"phone": "8867347448"}'
/// 
/// COMMON ISSUES
/// =============
/// 1. 404 Error
///    → Check if endpoint URL is correct
///    → Verify baseUrl in endpoints.dart
/// 
/// 2. Connection Refused
///    → Check if backend server is running
///    → Verify baseUrl is correct
/// 
/// 3. Invalid JSON Response
///    → Backend might be returning HTML error page
///    → Check server logs
/// 
/// 4. OTP not received
///    → Check if SMS gateway is configured on backend
///    → Check if phone number is valid
/// 
/// NEXT STEPS
/// ==========
/// After user receives OTP:
/// 1. User enters OTP in OTP screen
/// 2. OtpProvider.verifyOtp() is called
/// 3. Endpoint: /auth/login/verify-otp
/// 4. Request: {"phone": "8867347448", "otp": "123456"}
/// 5. Response: {"success": true, "token": "jwt_token_here"}
/// 6. Token is saved in StorageService
/// 7. User navigates to Dashboard or Profile completion screen
