// ============================================================
// register_controller.dart — Role Selection + Basic Info Controller
// Name, email, password, phone, aur role yahan se collect hote hain
// Actual API call patient_register ya doctor_register controller mein hoti hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---- State ----
class RegisterState {
  final String selectedRole; // "Patient" ya "Doctor"
  final bool isLoading;

  RegisterState({this.selectedRole = "Patient", this.isLoading = false});

  RegisterState copyWith({String? selectedRole, bool? isLoading}) {
    return RegisterState(
      selectedRole: selectedRole ?? this.selectedRole,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---- Notifier ----
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  // ---- Text controllers — register form ke fields ----
  final TextEditingController nameController = TextEditingController();    // Full name
  final TextEditingController emailController = TextEditingController();   // Email
  final TextEditingController passwordController = TextEditingController(); // Password
  final TextEditingController confirmPasswordController = TextEditingController(); // Confirm
  final TextEditingController phoneController = TextEditingController();   // Phone

  // ---- Role change karo ----
  void selectRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  // ---- Validation — saari basic fields check karo ----
  String? validateRegister() {
    if (nameController.text.trim().isEmpty) return "Naam daalen";
    if (emailController.text.trim().isEmpty) return "Email daalen";
    if (!emailController.text.contains('@')) return "Email sahi format mein daalen";
    if (phoneController.text.trim().isEmpty) return "Phone number daalen";
    if (passwordController.text.isEmpty) return "Password daalen";
    if (passwordController.text.length < 6) return "Password 6 ya zyada characters ka hona chahiye";
    if (passwordController.text != confirmPasswordController.text) {
      return "Dono passwords match nahi karte";
    }
    return null; // Sab theek hai
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
  }
}
