// ============================================================
// otp_screen.dart — OTP Verification (Backend Connected)
// forget_screen se email argument ke tor par aata hai
// Backend se OTP verify karta hai, phir resetPassword screen par jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/routes/app_routes.dart';
import '../widgets/otp_box_widget.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/common/logo_widget.dart';
import '../../../../core/providers/providers.dart';

class OtpVerificationScreen extends ConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpProvider);
    final notifier = ref.read(otpProvider.notifier);

    // ---- Forget screen se email argument lein ----
    // (forget_screen ne Navigator.pushNamed ke sath email pass ki thi)
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
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

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B3D),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---- Email show karo ----
              Center(
                child: Text(
                  email.isNotEmpty
                      ? "4-digit code $email par bheja gaya hai"
                      : "4-digit code apni email par check karein",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF757575), fontSize: 15),
                ),
              ),

              const SizedBox(height: 40),

              // ---- 4 OTP Boxes ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpBoxWidget(
                    controller: notifier.otp1Controller,
                    focusNode: notifier.otp1Focus,
                    nextFocus: notifier.otp2Focus,
                  ),
                  OtpBoxWidget(
                    controller: notifier.otp2Controller,
                    focusNode: notifier.otp2Focus,
                    nextFocus: notifier.otp3Focus,
                  ),
                  OtpBoxWidget(
                    controller: notifier.otp3Controller,
                    focusNode: notifier.otp3Focus,
                    nextFocus: notifier.otp4Focus,
                  ),
                  OtpBoxWidget(
                    controller: notifier.otp4Controller,
                    focusNode: notifier.otp4Focus,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // ---- Countdown Timer ----
              Center(
                child: Text(
                  "00:${state.secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF16B394),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---- Resend OTP Button (timer khatam hone par active hoga) ----
              Center(
                child: TextButton(
                  onPressed: !state.isTimerActive
                      ? () {
                          notifier.startTimer(); // Timer restart
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP Resend ho gaya")),
                          );
                        }
                      : null, // Timer chal raha hai toh disable
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: state.isTimerActive
                          ? Colors.grey
                          : const Color(0xFF16B394),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ---- Verify Button ----
              LoginButton(
                height: 55,
                width: double.infinity,
                text: state.isLoading ? "Verifying..." : "Verify OTP",
                onTap: state.isLoading
                    ? () {} // Loading mein block
                    : () async {
                        // Validation
                        final error = notifier.validateOtp();
                        if (error != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                          return;
                        }

                        try {
                          // Backend se OTP verify karo
                          await notifier.verifyOtp(email);

                          if (context.mounted) {
                            // Reset password screen par jao
                            // email aur otp dono pass karo
                            Navigator.pushNamed(
                              context,
                              AppRoutes.resetPassword,
                              arguments: {
                                'email': email,          // Email
                                'otp': notifier.getOtp(), // OTP jo enter kiya
                              },
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  e.toString().replaceAll('Exception: ', '')),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
