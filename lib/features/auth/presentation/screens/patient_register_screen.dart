// ============================================================
// patient_register_screen.dart — Patient Additional Info (Backend Connected)
// Register screen se name/email/password/phone arguments mein aate hain
// Yahan CNIC/DOB/Father Name/Age/BloodGroup collect hota hai
// Phir sab milakar backend ko bheja jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/success_dialog.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import 'package:medicare/core/widgets/form/date_of_birth_field.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/patient_age_field.dart';
import '../widgets/cnic_field.dart';
import '../widgets/father_name_field.dart';
import '../widgets/blood_group_field.dart';

class ARegisterScreen extends ConsumerWidget {
  const ARegisterScreen({super.key});

  // ---- Error snackbar ----
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientRegisterState = ref.watch(patientRegisterProvider);
    final patientRegisterNotifier = ref.read(patientRegisterProvider.notifier);

    // ---- Register screen se arguments lein ----
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final name = args?['name'] ?? '';       // Naam
    final email = args?['email'] ?? '';     // Email
    final password = args?['password'] ?? ''; // Password
    final phone = args?['phone'] ?? '';     // Phone

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
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.3,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Apni additional information provide karein",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 35),

                // ---- CNIC Field ----
                CNICTextField(controller: patientRegisterNotifier.cnicController),

                const SizedBox(height: 25),

                // ---- Date of Birth Field ----
                DOBTextField(controller: patientRegisterNotifier.dobController),

                const SizedBox(height: 25),

                // ---- Father's Name Field ----
                FatherNameTextField(
                    controller: patientRegisterNotifier.fatherNameController),

                const SizedBox(height: 28),

                // ---- Blood Group + Age Row ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Blood Group Dropdown — patientRegisterNotifier.setBloodGroup use karta hai
                    BloodGroupDropdown(
                      selectedValue: patientRegisterState.selectedBloodGroup,
                      onChanged: (val) =>
                          patientRegisterNotifier.setBloodGroup(val!),
                    ),
                    // Age Field
                    AgeTextField(
                        controller: patientRegisterNotifier.ageController),
                  ],
                ),

                const SizedBox(height: 38),

                // ---- Create Account Button ----
                LoginButton(
                  height: 55,
                  width: double.infinity,
                  text: patientRegisterState.isLoading
                      ? "Account Ban raha hai..."
                      : "Create Account",
                  onTap: patientRegisterState.isLoading
                      ? () {} // Loading mein block
                      : () async {
                          // Validation
                          final error = patientRegisterNotifier.validate();
                          if (error != null) {
                            _showError(context, error);
                            return;
                          }

                          try {
                            // Backend par register karo
                            // register screen se aaye data + yahan ka data
                            final success = await patientRegisterNotifier.register(
                              name: name,         // Register screen se
                              email: email,       // Register screen se
                              password: password, // Register screen se
                              phone: phone,       // Register screen se
                            );

                            if (success && context.mounted) {
                              // Success dialog dikhao
                              SuccessDialog.show(
                                context: context,
                                title: "Account Ban Gaya!",
                                subtitle:
                                    "Aapka patient account tayaar hai. Medicare mein khushaamdeed!",
                                buttonText: "Shuru Karein",
                                onPressed: () {
                                  // Sab screens band karke main screen par jao
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.mainLayout,
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
