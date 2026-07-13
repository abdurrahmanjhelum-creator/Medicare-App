import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

class ChangePasswordState {
  final bool isLoading;
  final String? error;

  ChangePasswordState({this.isLoading = false, this.error});

  ChangePasswordState copyWith({bool? isLoading, String? error}) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier() : super(ChangePasswordState());

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void disposeControllers() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  String? validate() {
    if (currentPasswordController.text.isEmpty) {
      return "Current password is required";
    }
    if (newPasswordController.text.isEmpty) {
      return "New password is required";
    }
    if (newPasswordController.text.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (confirmPasswordController.text.isEmpty) {
      return "Confirm password is required";
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<bool> changePassword() async {
    final error = validate();
    if (error != null) {
      state = state.copyWith(error: error);
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final body = {
        'currentPassword': currentPasswordController.text,
        'newPassword': newPasswordController.text,
        'confirmPassword': confirmPasswordController.text,
      };

      await ApiService.put(
        endpoint: '/users/change-password',
        body: body,
        auth: true,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}
