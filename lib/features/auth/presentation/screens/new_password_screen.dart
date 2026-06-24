// ============================================================
// new_password_screen.dart — Reset Password Screen (Backend Connected)
// OTP screen se email aur otp argument ke tor par aata hai
// Backend ko naya password bhejta hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/widgets/common/logo_widget.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import 'package:medicare/core/widgets/form/password_field.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/success_dialog.dart';
import '../../../../core/providers/providers.dart';

class Newpassword extends ConsumerWidget {
  const Newpassword({super.key});

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newPasswordProvider);
    final notifier = ref.watch(newPasswordProvider.notifier);

    // ---- OTP screen se email + otp arguments lein ----
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final email = args?['email'] ?? ''; // Email address
    final otp = args?['otp'] ?? '';     // Verified OTP

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ---- Back Button ----
                BackToLoginButton(
                  text: "Back",
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 30),

                // ---- Lock Icon ----
                const Center(
                  child: AppLogo(
                    height: 90,
                    width: 90,
                    iconcolor: Colors.white,
                    backgroundcolor: Color(0xFF16B394),
                    icon: Icons.lock_clock_outlined,
                  ),
                ),

                const SizedBox(height: 25),

                const Center(
                  child: Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B3D),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Center(
                  child: Text(
                    "Naya password daalen",
                    style: TextStyle(fontSize: 15, color: Color(0xFF757575)),
                  ),
                ),

                const SizedBox(height: 30),

                // ---- New Password Field ----
                PasswordTextField(
                  label: "Password",
                  hintText: "Naya password daalen",
                  controller: notifier.passwordController,
                ),

                const SizedBox(height: 25),

                // ---- Confirm Password Field ----
                PasswordTextField(
                  label: "Confirm Password",
                  hintText: "Password dobara daalen",
                  controller: notifier.confirmPasswordController,
                ),

                const SizedBox(height: 34),

                // ---- Reset Button ----
                LoginButton(
                  height: 55,
                  width: double.infinity,
                  text: state.isLoading ? "Resetting..." : "Reset Password",
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
                            // Backend ko naya password bhejo
                            await notifier.resetPassword(
                              email: email, // OTP screen se aaya
                              otp: otp,     // OTP screen se aaya
                            );

                            if (context.mounted) {
                              // Success dialog dikhao
                              SuccessDialog.show(
                                context: context,
                                title: "Password Reset Ho Gaya!",
                                subtitle:
                                    "Aapka password kamyabi se change ho gaya. Ab naye password se login karein.",
                                buttonText: "Login Par Jao",
                                onPressed: () {
                                  // Sab screens hatao aur login par jao
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
