import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// Custom error class for app-specific errors
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Error types for better error handling
enum ErrorType {
  network,
  validation,
  authentication,
  server,
  unknown,
}

/// Error handler utility for consistent error handling
class ErrorHandler {
  /// Handle error and return user-friendly message
  static String handleError(dynamic error) {
    if (error is AppError) {
      return error.message;
    }

    // Handle specific error types
    if (error.toString().contains('network') || 
        error.toString().contains('connection') ||
        error.toString().contains('SocketException')) {
      return AppStrings.networkError;
    }

    if (error.toString().contains('timeout')) {
      return 'Request timeout. Please try again.';
    }

    if (error.toString().contains('authentication') ||
        error.toString().contains('unauthorized')) {
      return 'Authentication failed. Please login again.';
    }

    if (error.toString().contains('validation')) {
      return AppStrings.somethingWentWrong;
    }

    // Default error message
    return AppStrings.somethingWentWrong;
  }

  /// Show error dialog
  static void showErrorDialog(
    BuildContext context,
    String message, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text(AppStrings.error),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: Text(AppStrings.tryAgain),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
