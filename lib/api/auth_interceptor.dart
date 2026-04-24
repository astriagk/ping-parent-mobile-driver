import '../api/services/auth_service.dart';
import '../api/services/storage_service.dart';
import '../helper/jwt_helper.dart';

/// Authentication interceptor that handles token validation and refresh
/// Validates token once on app startup, then uses local JWT decoding for efficiency
class AuthInterceptor {
  AuthService? _authService;
  final StorageService _storage;

  /// Token expiry threshold in seconds (5 minutes)
  /// If token expiry is within this threshold, it will be refreshed
  static const int tokenExpiryThreshold = 300;

  /// Flag to prevent multiple concurrent refresh attempts
  static bool _isRefreshing = false;

  /// Flag to indicate if startup validation has been completed
  static bool _startupValidationDone = false;

  AuthInterceptor({
    AuthService? authService,
    StorageService? storage,
  })  : _authService = authService,
        _storage = storage ?? StorageService();

  /// Set the AuthService instance (used after ApiClient is fully initialized)
  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  /// Validate token once on app startup
  /// This is called when the app launches to verify stored tokens
  Future<bool> validateTokenOnStartup() async {
    if (_startupValidationDone) {
      return true; // Already validated
    }

    try {
      final accessToken = await _storage.getAuthToken();
      final refreshToken = await _storage.getRefreshToken();

      // No tokens stored
      if (accessToken == null || refreshToken == null) {
        _startupValidationDone = true;
        return false;
      }

      // Call /auth/verify-token once to validate
      final response = await _verifyTokenWithServer();

      _startupValidationDone = true;
      return response;
    } catch (e) {
      _startupValidationDone = true;
      return false;
    }
  }

  /// Check token before making API calls
  /// Uses local JWT decoding (no API call) for efficiency
  /// Only calls /auth/verify-token if token is actually about to expire
  Future<bool> shouldProceedWithRequest() async {
    try {
      final accessToken = await _storage.getAuthToken();
      final refreshToken = await _storage.getRefreshToken();

      // No tokens available
      if (accessToken == null || refreshToken == null) {
        return false;
      }

      // Check if token is already expired (local check, no API call)
      if (JwtHelper.isTokenExpired(accessToken)) {
        return await _refreshTokenWithServer();
      }

      // Check if token is expiring within threshold (local check, no API call)
      if (JwtHelper.isTokenExpiringWithin(accessToken, tokenExpiryThreshold)) {
        return await _refreshTokenWithServer();
      }

      // Token is still valid - no API call needed
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify token with server (used on startup)
  Future<bool> _verifyTokenWithServer() async {
    try {
      if (_authService == null) {
        return false;
      }

      final response = await _authService!.verifyToken();

      if (response.success && response.data?.newToken != null) {
        // New token received
        return true;
      } else if (response.success && response.data?.tokenValid == true) {
        // Token is still valid
        return true;
      } else {
        // Token validation failed
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Refresh token with server (only called when token is about to expire)
  Future<bool> _refreshTokenWithServer() async {
    try {
      if (_authService == null) {
        return false;
      }

      // Prevent multiple simultaneous refresh attempts
      if (_isRefreshing) {
        await Future.delayed(const Duration(milliseconds: 500));
        final token = await _storage.getAuthToken();
        return token != null && !JwtHelper.isTokenExpired(token);
      }

      _isRefreshing = true;
      try {
        final response = await _authService!.verifyToken();

        if (response.success && response.data?.newToken != null) {
          // New token was successfully obtained
          return true;
        } else if (response.success && response.data?.tokenValid == true) {
          // Token is still valid, no refresh needed
          return true;
        } else {
          // Token refresh failed
          return false;
        }
      } finally {
        _isRefreshing = false;
      }
    } catch (e) {
      _isRefreshing = false;
      return false;
    }
  }

  /// Get current access token
  Future<String?> getAccessToken() async {
    return await _storage.getAuthToken();
  }

  /// Get current refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.getRefreshToken();
  }

  /// Check if token is valid without refresh
  Future<bool> isTokenValid() async {
    final token = await _storage.getAuthToken();
    if (token == null) return false;
    return !JwtHelper.isTokenExpired(token);
  }

  /// Get remaining time until token expiry in seconds
  Future<int?> getTokenExpiryTime() async {
    final token = await _storage.getAuthToken();
    if (token == null) return null;
    return JwtHelper.getTokenExpiryTime(token);
  }
}
