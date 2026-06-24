// ============================================================
// forget_screen.dart — Forgot Password Screen (Backend Connected)
// User email deta hai → backend OTP bhejta hai → OTP screen par jaata hai
// Email next screens ko argument ke tor par pass hoti hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/routes/app_routes.dart';
import 'package:medicare/core/widgets/common/logo_widget.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import 'package:medicare/core/widgets/form/email_text_field.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import '../../../../core/providers/providers.dart';

class Forgetscreen extends ConsumerWidget {
  const Forgetscreen({super.key});

  // ---- Error dikhao ----
  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider watch karo taake screen chalne tak dispose na ho
    final forgetState = ref.watch(forgetPasswordProvider);
    final forgetNotifier = ref.read(forgetPasswordProvider.notifier);

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
                  text: 'Back to Login',
                  onTap: () => Navigator.pop(context),
                ),

                const SizedBox(height: 25),

                // ---- Mail Icon ----
                const AppLogo(
                  height: 60,
                  width: 60,
                  iconcolor: Colors.white,
                  backgroundcolor: Color(0xFF16B394),
                  icon: Icons.mail,
                ),

                const SizedBox(height: 20),

                // ---- Heading ----
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0D1B3D),
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Email daalen aur hum OTP bhejenge password reset karne ke liye",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 30),

                // ---- Email Field ----
                EmailTextField(controller: forgetNotifier.emailController),

                const SizedBox(height: 25),

                // ---- Send OTP Button ----
                LoginButton(
                  height: 55,
                  width: double.infinity,
                  // Loading mein "Sending..." dikhao
                  text: forgetState.isLoading ? "Sending..." : "Send OTP",
                  onTap: forgetState.isLoading
                      ? () {} // Loading mein block karo
                      : () async {
                          // Validation
                          final error = forgetNotifier.validate();
                          if (error != null) {
                            _showError(context, error);
                            return;
                          }

                          try {
                            // Backend ko OTP bhejne ka request
                            await forgetNotifier.sendOtp();

                            if (context.mounted) {
                              // OTP screen par jao — email argument pass karo
                              // (OTP screen aur New Password screen ko email chahiye)
                              Navigator.pushNamed(
                                context,
                                AppRoutes.otp,
                                arguments: forgetNotifier.emailController.text.trim(),
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

                const SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
