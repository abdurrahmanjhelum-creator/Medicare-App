// ============================================================
// token_service.dart — JWT Token Storage
// Yeh class token ko phone ki local storage mein save/load karti hai
// shared_preferences library use hoti hai (key-value storage)
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  // Key naam — jis naam se storage mein token save hoga
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  // ---- Token save karo (login ke baad) ----
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token); // Token store karo
  }

  // ---- Token nikalo (API calls ke liye) ----
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey); // Token wapis do
  }

  // ---- User info save karo ----
  static Future<void> saveUserInfo({
    required String id,
    required String role,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);       // User ID
    await prefs.setString(_userRoleKey, role);   // Role: patient/doctor
    await prefs.setString(_userNameKey, name);   // Display name
    await prefs.setString(_userEmailKey, email); // Email
  }

  // ---- User ID nikalo ----
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // ---- User role nikalo (patient ya doctor) ----
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // ---- User name nikalo ----
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // ---- User email nikalo ----
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // ---- Poori info ek Map mein nikalo ----
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_userIdKey),
      'role': prefs.getString(_userRoleKey),
      'name': prefs.getString(_userNameKey),
      'email': prefs.getString(_userEmailKey),
    };
  }

  // ---- Login hai ya nahi check karo ----
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty; // Token hai toh logged in hai
  }

  // ---- Logout — sab data clear karo ----
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);    // Token delete karo
    await prefs.remove(_userIdKey);   // User ID delete karo
    await prefs.remove(_userRoleKey); // Role delete karo
    await prefs.remove(_userNameKey); // Name delete karo
    await prefs.remove(_userEmailKey);// Email delete karo
  }
}
