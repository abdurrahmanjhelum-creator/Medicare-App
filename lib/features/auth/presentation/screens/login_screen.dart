// ============================================================
// login_screen.dart — Login Screen (Backend Connected)
// LoginNotifier.login() call karta hai jo backend se JWT leta hai
// Success par mainLayout mein jaata hai
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_error.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/widgets/common/logo_widget.dart';
import '../../../../core/widgets/form/login_button.dart';
import '../../../../core/widgets/form/email_text_field.dart';
import '../../../../core/widgets/form/password_field.dart';
import '../../../../core/providers/providers.dart';

class Loginscreen extends ConsumerWidget {
  const Loginscreen({super.key});

  // ---- Error snackbar dikhao ----
  void _showError(BuildContext context, String msg) {
    ErrorHandler.showErrorSnackBar(context, msg);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Login state aur notifier subscribe karo
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
              vertical: AppDimensions.screenPaddingVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacing40),

                // ---- App Logo ----
                const AppLogo(
                  height: AppDimensions.avatarSize64,
                  width: AppDimensions.avatarSize64,
                  iconcolor: AppColors.white,
                  backgroundcolor: AppColors.primaryGreen,
                  icon: Icons.add_rounded,
                ),

                const SizedBox(height: AppDimensions.spacing24),

                // ---- Welcome Text ----
                const Text(
                  AppStrings.welcomeBack,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing4),

                const Text(
                  AppStrings.signInToContinue,
                  style: TextStyle(fontSize: 17, color: AppColors.textSecondary),
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // ---- Email Field ----
                EmailTextField(controller: loginNotifier.emailController),

                const SizedBox(height: AppDimensions.spacing28),

                // ---- Password Field ----
                PasswordTextField(
                  label: AppStrings.password,
                  hintText: "Password daalen",
                  controller: loginNotifier.passwordController,
                ),

                const SizedBox(height: AppDimensions.spacing24),

                // ---- Remember Me + Forgot Password ----
                Row(
                  children: [
                    // Remember Me checkbox
                    GestureDetector(
                      onTap: () => loginNotifier.toggleRememberMe(),
                      child: Container(
                        height: AppDimensions.iconSize24,
                        width: AppDimensions.iconSize24,
                        decoration: BoxDecoration(
                          color: loginState.rememberMe
                              ? AppColors.primaryGreen
                              : AppColors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppDimensions.radius4),
                        ),
                        child: loginState.rememberMe
                            ? const Icon(Icons.check,
                                size: AppDimensions.iconSize16,
                                color: AppColors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    const Text(
                      AppStrings.rememberMe,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    // Forgot Password link
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.forgetPassword),
                      child: const Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // ---- Login Button ----
                LoginButton(
                  height: AppDimensions.buttonHeight50,
                  width: double.infinity,
                  // Loading hai toh "Logging in..." dikhao
                  text: loginState.isLoading
                      ? "Logging in..."
                      : AppStrings.login,
                  onTap: loginState.isLoading
                      ? () {} // Loading mein tap block karo
                      : () async {
                          // Pehle validation karo
                          final error = loginNotifier.validateLogin();
                          if (error != null) {
                            _showError(context, error);
                            return;
                          }

                          // Backend se login karo
                          final success = await loginNotifier.login();

                          if (success) {
                            // Login successful — navigate based on role
                            final role = await TokenService.getUserRole();
                            if (!context.mounted) return;
                            if (role == 'doctor') {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.doctorMainLayout);
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.mainLayout);
                            }
                          } else if (!success && context.mounted) {
                            // Error show karo
                            _showError(
                                context,
                                loginState.error ?? 'Login fail ho gaya');
                          }
                        },
                ),

                const SizedBox(height: AppDimensions.spacing32),

                // ---- Register Link ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.dontHaveAccount),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text(
                        AppStrings.register,
                        style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
