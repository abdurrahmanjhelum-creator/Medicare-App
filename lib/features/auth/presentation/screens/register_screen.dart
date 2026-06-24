// ============================================================
// register_screen.dart — Create Account Screen (Updated)
// Yeh screen role select karti hai + name/email/password/phone leta hai
// Next button par patient ya doctor register screen par jaata hai
// Saara form data arguments ke tor par pass hota hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/common/back_button.dart';
import '../../../../core/widgets/form/email_text_field.dart';
import '../../../../core/widgets/form/login_button.dart';
import '../../../../core/widgets/form/password_field.dart';
import '../../../../core/widgets/form/full_name_field.dart';
import '../../../../core/widgets/form/phone_number_field.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/role.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  // ---- Error snackbar ----
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerState = ref.watch(registerProvider);
    final registerNotifier = ref.read(registerProvider.notifier);

    // ---- Local controllers (name, phone, confirm password) ----
    // Ye yahan isiliye hain kyunke register controller mein sirf email/password tha
    // Ab hum RegisterNotifier mein yeh bhi add kar dete hain
    // Lekin zyada simple approach: controllers seedha use karein

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
                  text: "Back to Login",
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 35),

                // ---- Heading ----
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.3,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Medicare Hospital mein khushaamdeed",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 35),

                // ---- Role Selection ----
                const Text(
                  "Role Select karein",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: RoleButton(
                        title: "Patient",
                        isSelected: registerState.selectedRole == "Patient",
                        onTap: () => registerNotifier.selectRole("Patient"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RoleButton(
                        title: "Doctor",
                        isSelected: registerState.selectedRole == "Doctor",
                        onTap: () => registerNotifier.selectRole("Doctor"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ---- Full Name Field ----
                // FullNameTextField internally apna controller manage karta hai
                // Isliye hum woh controller ref se access karenge
                FullNameTextField(controller: registerNotifier.nameController),

                const SizedBox(height: 25),

                // ---- Email Field ----
                EmailTextField(controller: registerNotifier.emailController),

                const SizedBox(height: 25),

                // ---- Phone Field ----
                PhoneNumberTextField(controller: registerNotifier.phoneController),

                const SizedBox(height: 25),

                // ---- Password Field ----
                PasswordTextField(
                  controller: registerNotifier.passwordController,
                  label: "Password",
                  hintText: "Password daalen",
                ),

                const SizedBox(height: 28),

                // ---- Confirm Password Field ----
                PasswordTextField(
                  controller: registerNotifier.confirmPasswordController,
                  label: "Confirm Password",
                  hintText: "Password dobara daalen",
                ),

                const SizedBox(height: 38),

                // ---- Next Button ----
                LoginButton(
                  height: 55,
                  width: double.infinity,
                  text: "Next",
                  onTap: () {
                    // Validation karo
                    final error = registerNotifier.validateRegister();
                    if (error != null) {
                      _showError(context, error);
                      return;
                    }

                    // Form data collect karo — next screen ko argument pass karo
                    final formData = {
                      'name': registerNotifier.nameController.text.trim(),
                      'email': registerNotifier.emailController.text.trim(),
                      'password': registerNotifier.passwordController.text,
                      'phone': registerNotifier.phoneController.text.trim(),
                    };

                    // Role ke hisaab se screen par jao
                    if (registerState.selectedRole == "Patient") {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.patientRegister,
                        arguments: formData, // Form data pass karo
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.doctorRegister,
                        arguments: formData, // Form data pass karo
                      );
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
