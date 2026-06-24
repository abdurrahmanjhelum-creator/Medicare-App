import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'token_service.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _port = '3000';

  static String get baseUrl {
    // Chrome ke liye 'localhost' sabse zyada reliable hai
    if (kIsWeb) return 'http://localhost:$_port/api';
    
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:$_port/api';
    } catch (e) {
      if (kDebugMode) debugPrint('Platform check error: $e');
    }
    
    return 'http://127.0.0.1:$_port/api';
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
    try {
      final token = auth ? await TokenService.getToken() : null;
      final url = Uri.parse('$baseUrl$endpoint');
      
      debugPrint('🚀 Requesting: $url');

      final response = await http
          .post(
            url,
            headers: _headers(token: token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Connection Error: $e');
      throw Exception('Server se contact nahi ho raha.\n1. Terminal mein backend chalayein.\n2. Check karein ke backend terminal mein "Server is running" likha hai.');
    }
  }

  static Future<Map<String, dynamic>> get({required String endpoint, bool auth = true, Map<String, String>? queryParams}) async {
    try {
      final token = auth ? await TokenService.getToken() : null;
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null) uri = uri.replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers(token: token)).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) { throw Exception('Request fail ho gayi: $e'); }
  }

  static Future<Map<String, dynamic>> patch({required String endpoint, required Map<String, dynamic> body, bool auth = true}) async {
    try {
      final token = auth ? await TokenService.getToken() : null;
      final response = await http.patch(Uri.parse('$baseUrl$endpoint'), headers: _headers(token: token), body: jsonEncode(body)).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) { throw Exception('Request fail ho gayi: $e'); }
  }

  static Future<Map<String, dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool auth = true}) async {
    try {
      final token = auth ? await TokenService.getToken() : null;
      final response = await http.put(Uri.parse('$baseUrl$endpoint'), headers: _headers(token: token), body: jsonEncode(body)).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) { throw Exception('Request fail ho gayi: $e'); }
  }

  static Future<Map<String, dynamic>> delete({required String endpoint, bool auth = true}) async {
    try {
      final token = auth ? await TokenService.getToken() : null;
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: _headers(token: token)).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) { throw Exception('Request fail ho gayi: $e'); }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    } else {
      throw Exception(body['message'] ?? 'Error: ${response.statusCode}');
    }
  }
}
