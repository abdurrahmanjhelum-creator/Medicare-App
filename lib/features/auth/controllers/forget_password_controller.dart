// ============================================================
// forget_password_controller.dart — Forgot Password (Backend)
// Backend ke /auth/forgot-password endpoint ko call karta hai
// Email bhejne par OTP generate ho jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart'; // HTTP POST ke liye

// ---- State ----
class ForgetPasswordState {
  final bool isLoading; // API call chal rahi hai ya nahi

  ForgetPasswordState({this.isLoading = false});

  ForgetPasswordState copyWith({bool? isLoading}) {
    return ForgetPasswordState(isLoading: isLoading ?? this.isLoading);
  }
}

// ---- Notifier ----
class ForgetPasswordNotifier extends StateNotifier<ForgetPasswordState> {
  ForgetPasswordNotifier() : super(ForgetPasswordState());

  // Email field controller
  final TextEditingController emailController = TextEditingController();

  // ---- Validation ----
  String? validate() {
    if (emailController.text.trim().isEmpty) return "Email daalen";
    return null;
  }

  // ============================================================
  // sendOtp() — Backend par email bhejo, OTP generate hoga
  // Return: true = email bhaaj gayi, false = error
  // ============================================================
  Future<bool> sendOtp() async {
    state = state.copyWith(isLoading: true);

    try {
      // POST /api/auth/forgot-password
      await ApiService.post(
        endpoint: '/auth/forgot-password',
        body: {'email': emailController.text.trim()}, // Email bhejo
      );

      state = state.copyWith(isLoading: false);
      return true; // OTP bhaj gayi

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow; // Error screen ko de do
    }
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    emailController.dispose();
  }
}
