import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:skolo_driver/config/environment.dart';

import 'services/storage_service.dart';

/// Enum for HTTP methods - provides type safety
enum HttpMethod { get, post, put, delete, patch }

/// HTTP Client for API communication
/// Automatically injects authentication token to all requests
class ApiClient {
  final http.Client _client;
  final StorageService _storage;
  late final Duration timeout;

  /// IMPORTANT: appConfig must be initialized before creating ApiClient.
  /// If not initialized, a default timeout of 30 seconds will be used.
  ApiClient({
    http.Client? client,
    StorageService? storage,
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? StorageService() {
    this.timeout =
        timeout ?? (appConfig?.requestTimeout ?? const Duration(seconds: 30));
  }

  /// Get headers with automatic auth token injection
  Future<Map<String, String>> getHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final token = await _storage.getAuthToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Encode body to JSON if it's a Map
  Object? _encodeBody(Object? body) {
    return body is Map ? json.encode(body) : body;
  }

  /// Generic HTTP request handler with timeout support
  Future<http.Response> _sendRequest(
    HttpMethod method,
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final requestHeaders = await getHeaders(additionalHeaders: headers);
      final uri = Uri.parse(url);
      final encodedBody = _encodeBody(body);

      final Future<http.Response> request = switch (method) {
        HttpMethod.get => _client.get(uri, headers: requestHeaders),
        HttpMethod.post =>
          _client.post(uri, headers: requestHeaders, body: encodedBody),
        HttpMethod.put =>
          _client.put(uri, headers: requestHeaders, body: encodedBody),
        HttpMethod.delete => _client.delete(uri, headers: requestHeaders),
        HttpMethod.patch =>
          _client.patch(uri, headers: requestHeaders, body: encodedBody),
      };

      return await request.timeout(timeout);
    } on SocketException catch (_) {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException catch (_) {
      throw Exception('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Response format error: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// GET request
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _sendRequest(HttpMethod.get, url, headers: headers);
  }

  /// POST request
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendRequest(HttpMethod.post, url, headers: headers, body: body);
  }

  /// PUT request
  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendRequest(HttpMethod.put, url, headers: headers, body: body);
  }

  /// DELETE request
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest(HttpMethod.delete, url, headers: headers);
  }

  /// PATCH request
  Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _sendRequest(HttpMethod.patch, url, headers: headers, body: body);
  }

  /// Close the HTTP client and release resources
  void close() {
    _client.close();
  }
}
