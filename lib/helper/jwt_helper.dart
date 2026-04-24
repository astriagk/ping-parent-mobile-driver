import 'dart:convert';

class JwtHelper {
  /// Decode JWT token and extract payload
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decode the payload (second part)
      final String normalized = base64Url.normalize(parts[1]);
      final String decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payload = jsonDecode(decoded);

      return payload;
    } catch (e) {
      return null;
    }
  }

  /// Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return true;

      final exp = payload['exp'] as int?;
      if (exp == null) return true;

      // exp is in seconds, compare with current time
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  /// Get remaining time until token expiry in seconds
  static int? getTokenExpiryTime(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return null;

      final exp = payload['exp'] as int?;
      if (exp == null) return null;

      final remainingSeconds =
          exp - DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return remainingSeconds > 0 ? remainingSeconds : 0;
    } catch (e) {
      return null;
    }
  }

  /// Check if token expiry is within threshold (e.g., < 5 minutes remaining)
  static bool isTokenExpiringWithin(String token, int thresholdSeconds) {
    final remaining = getTokenExpiryTime(token);
    if (remaining == null) return true;
    return remaining < thresholdSeconds;
  }
}
