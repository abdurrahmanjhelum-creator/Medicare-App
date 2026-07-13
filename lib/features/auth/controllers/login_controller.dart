// ============================================================
// login_controller.dart — Login Logic (Backend Connected)
// LoginNotifier backend ke /auth/login endpoint se baat karta hai
// JWT token milne par TokenService mein save ho jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';    // HTTP calls ke liye
import '../../../core/services/token_service.dart';  // Token store karne ke liye

// ---- State class — login screen ki state ----
class LoginState {
  final bool rememberMe;  // Remember Me checkbox ka state
  final bool isLoading;   // API call chal rahi hai ya nahi
  final String? error;    // Error message (agar koi fail ho)

  LoginState({
    this.rememberMe = false,
    this.isLoading = false,
    this.error,
  });

  // copyWith — state ka sirf ek part change karo, baaki same raho
  LoginState copyWith({bool? rememberMe, bool? isLoading, String? error}) {
    return LoginState(
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// ---- Notifier class — login ka actual logic ----
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState()); // Shuru mein default state

  // Text fields ke controllers — screen se input lene ke liye
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ---- Remember Me toggle ----
  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  // ---- Basic validation — fields khali toh nahi? ----
  String? validateLogin() {
    if (emailController.text.trim().isEmpty) return "Email daalen";
    if (passwordController.text.trim().isEmpty) return "Password daalen";
    return null; // Null = koi error nahi
  }

  // ============================================================
  // login() — Backend se actual login karo
  // Return: true = success, false = fail
  // ============================================================
  Future<bool> login() async {
    // Loading shuru karo
    state = state.copyWith(isLoading: true, error: null);

    try {
      // POST /api/auth/login — email aur password bhejo
      final response = await ApiService.post(
        endpoint: '/auth/login',
        body: {
          'email': emailController.text.trim(),    // Email (spaces hataao)
          'password': passwordController.text,     // Password
        },
      );

      // Backend se access_token aur user aata hai
      // Response format: { data: { access_token: '...', user: {...} } }
      final data = ApiService.unwrapMap(response);
      final token = data['access_token'] as String;
      final user = data['user'] as Map<String, dynamic>;

      // Token phone storage mein save karo
      await TokenService.saveToken(token);

      // User ki info bhi save karo
      await TokenService.saveUserInfo(
        id: user['id'] as String,
        role: user['role'] as String,     // patient ya doctor
        name: user['name'] as String,
        email: user['email'] as String,
      );

      // Loading band karo
      state = state.copyWith(isLoading: false);
      return true; // Login successful

    } catch (e) {
      // Error aaya — message nikalo aur show karo
      final errMsg = e.toString().replaceAll('Exception: ', '');
      state = state.copyWith(isLoading: false, error: errMsg);
      return false; // Login fail
    }
  }

  // ---- Controllers dispose karo jab screen band ho ----
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }
}
