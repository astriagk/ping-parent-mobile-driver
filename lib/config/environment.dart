/// Environment configuration for different build flavors
enum Environment { development, staging, production }

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
    requestTimeout: Duration(seconds: 30),
  );

  /// Staging environment configuration
  static const EnvironmentConfig staging = EnvironmentConfig(
    environment: Environment.staging,
    baseUrl: 'https://ping-parent-backend-staging.onrender.com/api',
    enableLogging: true,
    requestTimeout: Duration(seconds: 30),
  );

  /// Production environment configuration
  static const EnvironmentConfig production = EnvironmentConfig(
    environment: Environment.production,
    baseUrl: 'https://ping-parent-backend-m8yc.onrender.com/api',
    enableLogging: false,
    requestTimeout: Duration(seconds: 30),
  );

  /// Get configuration based on environment
  static EnvironmentConfig getConfig(Environment env) {
    return switch (env) {
      Environment.development => development,
      Environment.staging => staging,
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
/// This should be initialized in main.dart based on build flavor
late EnvironmentConfig appConfig;

/// Initialize app configuration
void initializeEnvironment(Environment env) {
  appConfig = EnvironmentConfig.getConfig(env);
  print('🔧 Environment initialized: ${appConfig.toString()}');
}
