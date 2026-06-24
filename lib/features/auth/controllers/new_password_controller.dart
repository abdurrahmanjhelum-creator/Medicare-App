// ============================================================
// new_password_controller.dart — Reset Password (Backend)
// Backend ke /auth/reset-password endpoint se naya password set karta hai
// Email aur OTP bhi chahiye (forget_screen se pass hote hain)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart'; // API call ke liye

// ---- State ----
class NewPasswordState {
  final bool isLoading; // API call chal rahi hai ya nahi

  NewPasswordState({this.isLoading = false});

  NewPasswordState copyWith({bool? isLoading}) {
    return NewPasswordState(isLoading: isLoading ?? this.isLoading);
  }
}

// ---- Notifier ----
class NewPasswordNotifier extends StateNotifier<NewPasswordState> {
  NewPasswordNotifier() : super(NewPasswordState());

  // New password aur confirm password ke controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // ---- Validation ----
  String? validate() {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return "Saari fields bharein";
    }
    if (passwordController.text != confirmPasswordController.text) {
      return "Dono passwords match nahi karte";
    }
    if (passwordController.text.length < 6) {
      return "Password kam se kam 6 characters ka hona chahiye";
    }
    return null;
  }

  // ============================================================
  // resetPassword() — Backend par naya password set karo
  // email — forget_screen se aata hai
  // otp   — otp_screen se aata hai
  // ============================================================
  Future<bool> resetPassword({
    required String email, // Jis email par OTP bheja tha
    required String otp,   // OTP jo user ne enter kiya
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // POST /api/auth/reset-password
      await ApiService.post(
        endpoint: '/auth/reset-password',
        body: {
          'email': email,                        // Email address
          'otp': otp,                            // OTP code
          'newPassword': passwordController.text, // Naya password
        },
      );

      state = state.copyWith(isLoading: false);
      return true; // Password reset ho gaya

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
