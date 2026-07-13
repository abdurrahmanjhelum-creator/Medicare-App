// ============================================================
// patient_register_controller.dart — Patient Registration (Backend)
// Backend ke /auth/register/patient endpoint se connect hai
// Register screen se data leta hai aur API ko bhejta hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';    // HTTP POST ke liye
import '../../../core/services/token_service.dart';  // Token save ke liye

// ---- State — patient register screen ki state ----
class PatientRegisterState {
  final bool isLoading;      // API call chal rahi hai ya nahi
  final String selectedBloodGroup; // Blood group dropdown ki value

  PatientRegisterState({
    this.isLoading = false,
    this.selectedBloodGroup = 'A+', // Default blood group
  });

  PatientRegisterState copyWith({bool? isLoading, String? selectedBloodGroup}) {
    return PatientRegisterState(
      isLoading: isLoading ?? this.isLoading,
      selectedBloodGroup: selectedBloodGroup ?? this.selectedBloodGroup,
    );
  }
}

// ---- Notifier — registration logic ----
class PatientRegisterNotifier extends StateNotifier<PatientRegisterState> {
  PatientRegisterNotifier() : super(PatientRegisterState());

  // ---- Text field controllers ----
  final TextEditingController nameController = TextEditingController();     // Naam
  final TextEditingController emailController = TextEditingController();    // Email
  final TextEditingController passwordController = TextEditingController(); // Password
  final TextEditingController phoneController = TextEditingController();    // Phone
  final TextEditingController cnicController = TextEditingController();     // CNIC
  final TextEditingController dobController = TextEditingController();      // Date of Birth
  final TextEditingController fatherNameController = TextEditingController(); // Baap ka naam
  final TextEditingController ageController = TextEditingController();      // Umar

  // ---- Blood group change karo ----
  void setBloodGroup(String value) {
    state = state.copyWith(selectedBloodGroup: value);
  }

  // ---- Validation — saari fields check karo ----
  String? validate() {
    if (cnicController.text.trim().isEmpty) return "CNIC daalen";
    if (dobController.text.trim().isEmpty) return "Date of Birth daalen";
    if (fatherNameController.text.trim().isEmpty) return "Father ka naam daalen";
    if (ageController.text.trim().isEmpty) return "Umar daalen";
    return null; // Sab theek hai
  }

  // ============================================================
  // register() — Backend par patient register karo
  // Register screen se name/email/password, yahan se CNIC/DOB etc.
  // Dono milake backend ko bhejo
  // ============================================================
  Future<bool> register({
    required String name,    // Register screen se aata hai
    required String email,   // Register screen se aata hai
    required String password,// Register screen se aata hai
    required String phone,   // Register screen se aata hai
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // POST /api/auth/register/patient
      final response = await ApiService.post(
        endpoint: '/auth/register/patient',
        body: {
          'name': name,                              // Patient ka naam
          'email': email,                            // Email address
          'password': password,                      // Password
          'phone': phone,                            // Phone number
          'cnic': cnicController.text.trim(),        // CNIC number
          'dob': dobController.text.trim(),          // Date of birth string
          'fatherName': fatherNameController.text.trim(), // Father name
          'age': int.tryParse(ageController.text.trim()) ?? 0, // Umar (int)
          'bloodGroup': state.selectedBloodGroup,   // Blood group
        },
      );

      // Token aur user info save karo
      final data = response['data'] ?? response;
      await TokenService.saveToken(data['access_token'] as String);
      final user = data['user'] as Map<String, dynamic>;
      await TokenService.saveUserInfo(
        id: user['id'] as String,
        role: user['role'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
        phone: user['phone'] as String?, // Added phone here
      );

      state = state.copyWith(isLoading: false);
      return true; // Registration successful

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow; // Error upar screen ko de do taake woh show kar sake
    }
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    dobController.dispose();
    fatherNameController.dispose();
    ageController.dispose();
  }
}
