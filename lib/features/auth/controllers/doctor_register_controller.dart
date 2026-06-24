// ============================================================
// doctor_register_controller.dart — Doctor Registration (Backend)
// Backend ke /auth/register/doctor endpoint se connect hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';    // API calls ke liye
import '../../../core/services/token_service.dart';  // Token save ke liye

// ---- State — doctor register screen ki state ----
class DoctorRegisterState {
  final String selectedSpecialization;  // Doctor ki specialty
  final String selectedQualification;   // Degree (MBBS etc.)
  final int experienceYears;            // Kitne saal ka experience
  final List<String> selectedDays;      // Available days (Mon, Tue...)
  final bool isLoading;                 // API call chal rahi hai ya nahi

  DoctorRegisterState({
    this.selectedSpecialization = "General Physician",
    this.selectedQualification = "MBBS",
    this.experienceYears = 0,
    this.selectedDays = const [],
    this.isLoading = false,
  });

  DoctorRegisterState copyWith({
    String? selectedSpecialization,
    String? selectedQualification,
    int? experienceYears,
    List<String>? selectedDays,
    bool? isLoading,
  }) {
    return DoctorRegisterState(
      selectedSpecialization: selectedSpecialization ?? this.selectedSpecialization,
      selectedQualification: selectedQualification ?? this.selectedQualification,
      experienceYears: experienceYears ?? this.experienceYears,
      selectedDays: selectedDays ?? this.selectedDays,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---- Notifier — doctor registration ka logic ----
class DoctorRegisterNotifier extends StateNotifier<DoctorRegisterState> {
  DoctorRegisterNotifier() : super(DoctorRegisterState());

  // ---- Text field controllers ----
  final TextEditingController licenseController = TextEditingController();  // PMDC License
  final TextEditingController clinicController = TextEditingController();   // Clinic address
  final TextEditingController feeController = TextEditingController();      // Consultation fee
  final TextEditingController bioController = TextEditingController();      // Bio/description

  // ---- Specialization set karo ----
  void setSpecialization(String value) {
    state = state.copyWith(selectedSpecialization: value);
  }

  // ---- Qualification set karo ----
  void setQualification(String value) {
    state = state.copyWith(selectedQualification: value);
  }

  // ---- Experience years set karo ----
  void setExperience(int value) {
    state = state.copyWith(experienceYears: value);
  }

  // ---- Day toggle karo (select/deselect) ----
  void toggleDay(String day, bool isSelected) {
    final currentDays = List<String>.from(state.selectedDays);
    if (isSelected) {
      if (!currentDays.contains(day)) currentDays.add(day); // Add karo
    } else {
      currentDays.remove(day); // Hata do
    }
    state = state.copyWith(selectedDays: currentDays);
  }

  // ---- Validation ----
  String? validate() {
    if (licenseController.text.trim().isEmpty) return "PMDC License No daalen";
    if (state.selectedDays.isEmpty) return "Kam se kam ek din select karo";
    if (bioController.text.trim().isEmpty) return "Bio zaroori hai";
    return null;
  }

  // ============================================================
  // register() — Backend par doctor register karo
  // ============================================================
  Future<bool> register({
    required String name,     // Register screen se aata hai
    required String email,    // Register screen se aata hai
    required String password, // Register screen se aata hai
    required String phone,    // Register screen se aata hai
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // POST /api/auth/register/doctor
      final response = await ApiService.post(
        endpoint: '/auth/register/doctor',
        body: {
          'name': name,                                        // Doctor ka naam
          'email': email,                                      // Email
          'password': password,                                // Password
          'phone': phone,                                      // Phone
          'pmdcLicenceNumber': licenseController.text.trim(), // PMDC number
          'specialization': state.selectedSpecialization,     // Specialty
          'qualification': state.selectedQualification,       // Degree
          'experience': state.experienceYears,                  // Experience (integer years)
          'clinic': clinicController.text.trim(),             // Clinic address
          'fee': double.tryParse(feeController.text) ?? 0.0, // Fee (number)
          'bio': bioController.text.trim(),                   // Bio
          'availableDays': state.selectedDays,                // Days list
        },
      );

      // Token save karo
      final data = response['data'] ?? response;
      await TokenService.saveToken(data['access_token'] as String);
      final user = data['user'] as Map<String, dynamic>;
      await TokenService.saveUserInfo(
        id: user['id'] as String,
        role: user['role'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
      );

      state = state.copyWith(isLoading: false);
      return true;

    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  // ---- Controllers dispose karo ----
  void disposeControllers() {
    licenseController.dispose();
    clinicController.dispose();
    feeController.dispose();
    bioController.dispose();
  }
}
