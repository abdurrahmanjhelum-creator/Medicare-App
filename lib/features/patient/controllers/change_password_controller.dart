import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordState {
  final bool isLoading;

  ChangePasswordState({this.isLoading = false});

  ChangePasswordState copyWith({bool? isLoading}) {
    return ChangePasswordState(isLoading: isLoading ?? this.isLoading);
  }
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier() : super(ChangePasswordState());

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void disposeControllers() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  String? validate() {
    if (passwordController.text.isEmpty) {
      return "Please enter a password";
    }
    if (passwordController.text != confirmPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }
}
