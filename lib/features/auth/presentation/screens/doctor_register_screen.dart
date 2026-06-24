// ============================================================
// doctor_register_screen.dart — Doctor Professional Info (Backend Connected)
// Register screen se name/email/password/phone arguments mein aate hain
// Yahan professional details collect hoti hain
// Phir sab milakar backend ko bheja jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/success_dialog.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/license_field.dart';
import '../widgets/specialization_dropdown.dart';
import '../widgets/qualification_dropdown.dart';
import '../widgets/experience_dropdown.dart';
import '../widgets/clinic_field.dart';
import '../widgets/fee_field.dart';
import '../widgets/available_days_widget.dart';
import '../widgets/bio_field.dart';

class DoctorRegisterScreen extends ConsumerWidget {
  const DoctorRegisterScreen({super.key});

  // ---- Error snackbar ----
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorRegisterProvider);
    final notifier = ref.read(doctorRegisterProvider.notifier);

    // ---- Register screen se arguments lein ----
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final name = args?['name'] ?? '';
    final email = args?['email'] ?? '';
    final password = args?['password'] ?? '';
    final phone = args?['phone'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ---- Back Button ----
                BackToLoginButton(
                  text: "Back",
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 35),

                // ---- Heading ----
                const Text(
                  "Professional Info",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.3,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Apni professional details provide karein",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 35),

                // ---- PMDC License Field ----
                LicenseField(controller: notifier.licenseController),

                const SizedBox(height: 25),

                // ---- Specialization Dropdown ----
                SpecializationDropdown(
                  value: state.selectedSpecialization,
                  onChanged: (value) => notifier.setSpecialization(value!),
                ),

                const SizedBox(height: 25),

                // ---- Qualification Dropdown ----
                QualificationDropdown(
                  value: state.selectedQualification,
                  onChanged: (value) => notifier.setQualification(value!),
                ),

                const SizedBox(height: 25),

                // ---- Experience Dropdown ----
                ExperienceDropdown(
                  value: state.experienceYears,
                  onChanged: (value) => notifier.setExperience(value!),
                ),

                const SizedBox(height: 25),

                // ---- Clinic Address Field ----
                ClinicField(controller: notifier.clinicController),

                const SizedBox(height: 25),

                // ---- Consultation Fee Field ----
                FeeField(controller: notifier.feeController),

                const SizedBox(height: 25),

                // ---- Available Days Widget ----
                AvailableDaysWidget(
                  selectedDays: state.selectedDays,
                  onDaySelected: (day, isSelected) {
                    notifier.toggleDay(day, isSelected);
                  },
                ),

                const SizedBox(height: 25),

                // ---- Bio Field ----
                BioField(controller: notifier.bioController),

                const SizedBox(height: 38),

                // ---- Create Doctor Account Button ----
                LoginButton(
                  height: 55,
                  width: double.infinity,
                  text: state.isLoading
                      ? "Account Ban raha hai..."
                      : "Create Doctor Account",
                  onTap: state.isLoading
                      ? () {} // Loading mein block
                      : () async {
                          // Validation
                          final error = notifier.validate();
                          if (error != null) {
                            _showError(context, error);
                            return;
                          }

                          try {
                            // Backend par register karo
                            final success = await notifier.register(
                              name: name,         // Register screen se
                              email: email,       // Register screen se
                              password: password, // Register screen se
                              phone: phone,       // Register screen se
                            );

                            if (success && context.mounted) {
                              // Success dialog
                              SuccessDialog.show(
                                context: context,
                                title: "Registration Kamyab!",
                                subtitle:
                                    "Aapka doctor profile ban gaya. Hamari team aapka PMDC license verify karegi.",
                                buttonText: "Theek Hai",
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.doctorMainLayout,
                                    (route) => false,
                                  );
                                },
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              _showError(context,
                                  e.toString().replaceAll('Exception: ', ''));
                            }
                          }
                        },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
