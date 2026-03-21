/// Environment configuration for different build flavors
enum Environment { development, production }

/// Environment-specific API configuration
class EnvironmentConfig {
  final Environment environment;
  final String baseUrl;
  final bool enableLogging;
  final Duration requestTimeout;

  const EnvironmentConfig({
    required this.environment,
    required this.baseUrl,
    this.enableLogging = false,
    this.requestTimeout = const Duration(seconds: 30),
  });

  /// Development environment configuration
  static const EnvironmentConfig development = EnvironmentConfig(
    environment: Environment.development,
    baseUrl: 'http://localhost:3000/api',
    enableLogging: true,
  );

  /// Production environment configuration
  static const EnvironmentConfig production = EnvironmentConfig(
    environment: Environment.production,
    baseUrl: 'https://ping-parent-backend-m8yc.onrender.com/api',
    enableLogging: false,
  );

  /// Get configuration based on environment
  static EnvironmentConfig getConfig(Environment env) {
    return switch (env) {
      Environment.development => development,
      Environment.production => production,
    };
  }

  @override
  String toString() => 'EnvironmentConfig('
      'environment: $environment, '
      'baseUrl: $baseUrl, '
      'enableLogging: $enableLogging, '
      'requestTimeout: $requestTimeout)';
}

/// Global environment configuration instance
/// IMPORTANT: You must call initializeEnvironment() in main.dart before using any API or config.
/// Example:
///   void main() {
///     initializeEnvironment(Environment.production);
///     runApp(const MyApp());
///   }
late EnvironmentConfig _appConfig;

/// Safe getter for appConfig. Throws if not initialized.
EnvironmentConfig get appConfig {
  if (!_isAppConfigInitialized) {
    throw StateError(
        'appConfig has not been initialized. Call initializeEnvironment() in main.dart before using any API/config.');
  }
  return _appConfig;
}

bool _isAppConfigInitialized = false;

/// Initialize app configuration
void initializeEnvironment(Environment env) {
  _appConfig = EnvironmentConfig.getConfig(env);
  _isAppConfigInitialized = true;
}
