import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/auth/controllers/register_controller.dart';
import '../../features/auth/controllers/doctor_register_controller.dart';
import '../../features/auth/controllers/patient_register_controller.dart';
import '../../features/auth/controllers/forget_password_controller.dart';
import '../../features/auth/controllers/otp_controller.dart';
import '../../features/auth/controllers/new_password_controller.dart';

// Login Provider
final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
      final notifier = LoginNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });

// Register Provider
final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>((ref) {
      final notifier = RegisterNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });

// Doctor Register Provider
final doctorRegisterProvider =
    StateNotifierProvider.autoDispose<
      DoctorRegisterNotifier,
      DoctorRegisterState
    >((ref) {
      final notifier = DoctorRegisterNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });

// Patient Register Provider
final patientRegisterProvider =
    StateNotifierProvider.autoDispose<
      PatientRegisterNotifier,
      PatientRegisterState
    >((ref) {
      final notifier = PatientRegisterNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });

// Forget Password Provider
final forgetPasswordProvider =
    StateNotifierProvider.autoDispose<
      ForgetPasswordNotifier,
      ForgetPasswordState
    >((ref) {
      final notifier = ForgetPasswordNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });

// OTP Provider
final otpProvider = StateNotifierProvider.autoDispose<OtpNotifier, OtpState>((
  ref,
) {
  final notifier = OtpNotifier();
  ref.onDispose(() => notifier.disposeControllers());
  return notifier;
});

// New Password Provider
final newPasswordProvider =
    StateNotifierProvider.autoDispose<NewPasswordNotifier, NewPasswordState>((
      ref,
    ) {
      final notifier = NewPasswordNotifier();
      ref.onDispose(() => notifier.disposeControllers());
      return notifier;
    });
