import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/providers/providers.dart';
import 'package:medicare/core/widgets/common/header.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import 'package:medicare/core/widgets/form/password_field.dart';
import 'package:medicare/core/widgets/form/login_button.dart';

class NewPasswordScreen extends ConsumerWidget {
  const NewPasswordScreen({super.key});

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIX: Must watch the provider to prevent it from disposing while the screen is active
    ref.watch(changePasswordProvider);
    final notifier = ref.read(changePasswordProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
              firstColor: const Color(0xff089B73),
              secondColor: const Color(0xff28C7C0),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PasswordTextField(
                    controller: notifier.passwordController,
                    label: "Password",
                    hintText: "Enter your password",
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    controller: notifier.confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Confirm your password",
                  ),
                  const SizedBox(height: 40),
                  LoginButton(
                    height: 55,
                    width: double.infinity,
                    text: "Save Changes",
                    onTap: () {
                      final error = notifier.validate();
                      if (error != null) {
                        _showError(context, error);
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password Updated Successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    },
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
