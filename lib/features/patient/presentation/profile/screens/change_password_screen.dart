import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/constants/app_colors.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/header.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/form/password_field.dart';
import 'package:medicare/core/widgets/form/login_button.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  @override
  void dispose() {
    ref.read(changePasswordProvider.notifier).disposeControllers();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  Future<void> _onSave() async {
    final success = await ref.read(changePasswordProvider.notifier).changePassword();
    
    if (!mounted) return;

    if (success) {
      _showSuccess('Password changed successfully');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      final error = ref.read(changePasswordProvider).error;
      final errorMessage = error?.contains('Exception:') == true
          ? error!.replaceAll('Exception: ', '')
          : error ?? 'Failed to change password';
      _showError('Error: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordState = ref.watch(changePasswordProvider);
    final notifier = ref.read(changePasswordProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorListHeader(
              title: "Change Password",
              shortText: "Update your security credentials",
              showSearch: false,
              leading: BackToLoginButton(
                onTap: () => Navigator.pop(context),
                text: "Back",
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PasswordTextField(
                    controller: notifier.currentPasswordController,
                    label: "Current Password",
                    hintText: "Enter your current password",
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    controller: notifier.newPasswordController,
                    label: "New Password",
                    hintText: "Enter your new password",
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    controller: notifier.confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Confirm your new password",
                  ),
                  const SizedBox(height: 40),
                  LoginButton(
                    height: 55,
                    width: double.infinity,
                    text: changePasswordState.isLoading ? "Updating..." : "Save Changes",
                    onTap: changePasswordState.isLoading ? () {} : _onSave,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
