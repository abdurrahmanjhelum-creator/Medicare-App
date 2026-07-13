import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class ApiService {
  // Override with:
  // flutter run --dart-define=API_BASE_URL=http://<your-ip>:3000/api
  static const String _customBaseUrl = String.fromEnvironment('API_BASE_URL');

  // LOCAL BACKEND (running via npm run start:dev)
  // For web/Chrome: use localhost
  // For Android emulator: use 10.0.2.2 (alias for host machine)
  // For iOS simulator: use localhost
  static String get _localUrl => kIsWeb
      ? 'http://localhost:3000/api'
      : Platform.isAndroid
          ? 'http://10.0.2.2:3000/api'
          : 'http://localhost:3000/api';

  // LIVE PRODUCTION URL (Vercel)
  static const String _productionUrl =
      'https://medicare-app-backend.vercel.app/api';

  // Default to production URL to avoid IP issues on real devices
  static String get baseUrl =>
      _customBaseUrl.isNotEmpty ? _customBaseUrl : _productionUrl;

  /// Backend { data: ... } wrapper hatao
  static dynamic unwrap(Map<String, dynamic> response) {
    return response['data'] ?? response;
  }

  /// List extract karo — appointments, doctors, notifications, etc.
  static List<dynamic> unwrapList(
    Map<String, dynamic> response, {
    String? listKey,
  }) {
    final data = unwrap(response);
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      if (listKey != null && data[listKey] is List) {
        return data[listKey] as List;
      }
      for (final key in [
        'appointments',
        'doctors',
        'notifications',
        'medicines',
        'records',
        'medicalRecords',
        'contacts',
        'reviews',
        'items',
      ]) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  static Map<String, dynamic> unwrapMap(Map<String, dynamic> response) {
    final data = unwrap(response);
    return data is Map<String, dynamic> ? data : response;
  }

  static Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    bool auth = false,
  }) async {
    return _request(() async {
      final token = auth ? await TokenService.getToken() : null;
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🚀 POST: $url');
      final response = await http
          .post(url, headers: _headers(token: token), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    });
  }

  static Future<Map<String, dynamic>> get({
    required String endpoint,
    bool auth = true,
    Map<String, String>? queryParams,
  }) async {
    return _request(() async {
      final token = auth ? await TokenService.getToken() : null;
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }
      debugPrint('🚀 GET: $uri');
      final response = await http
          .get(uri, headers: _headers(token: token))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    });
  }

  static Future<Map<String, dynamic>> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    bool auth = true,
  }) async {
    return _request(() async {
      final token = auth ? await TokenService.getToken() : null;
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🚀 PATCH: $url');
      final response = await http
          .patch(url, headers: _headers(token: token), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    });
  }

  static Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    bool auth = true,
  }) async {
    return _request(() async {
      final token = auth ? await TokenService.getToken() : null;
      final url = Uri.parse('$baseUrl$endpoint');
      debugPrint('🚀 PUT: $url');
      final response = await http
          .put(url, headers: _headers(token: token), body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    });
  }

  static Future<Map<String, dynamic>> delete({
    required String endpoint,
    bool auth = true,
    Map<String, dynamic>? body,
  }) async {
    return _request(() async {
      final token = auth ? await TokenService.getToken() : null;
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('🚀 DELETE: $uri');
      final response = await http
          .delete(
            uri,
            headers: _headers(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    });
  }

  static Future<Map<String, dynamic>> _request(
    Future<Map<String, dynamic>> Function() fn,
  ) async {
    try {
      return await fn();
    } on SocketException catch (e) {
      debugPrint('❌ Connection Error: $e');
      throw Exception(
        'Server se contact nahi ho raha.\n'
        '1. Internet check karein\n'
        '2. API URL: $baseUrl',
      );
    } on TimeoutException {
      debugPrint('❌ Timeout — $baseUrl reachable nahi');
      throw Exception(
        'Server respond nahi kar raha (timeout).\n'
        'URL: $baseUrl',
      );
    } catch (e) {
      if (e is FormatException || e is TypeError) rethrow;
      debugPrint('❌ Request Error: $e');
      rethrow;
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};
    final body = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body['message'];
    if (message is List) {
      throw Exception(message.join(', '));
    }
    throw Exception(message?.toString() ?? 'Error: ${response.statusCode}');
  }
}
