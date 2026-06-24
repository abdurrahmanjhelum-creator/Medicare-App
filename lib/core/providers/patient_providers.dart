import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/patient/controllers/home_controller.dart';
import '../../features/patient/controllers/appointment_controller.dart';
import '../../features/patient/controllers/doctor_controller.dart';
import '../../features/patient/controllers/emergency_controller.dart';
import '../../features/patient/controllers/notification_controller.dart';
import '../../features/patient/controllers/pharmacy_controller.dart';
import '../../features/patient/controllers/report_controller.dart';
import '../../features/patient/controllers/change_password_controller.dart';

// Home Provider
final homeProvider = ChangeNotifierProvider.autoDispose((ref) {
  return HomeController();
});

// Appointment Provider
final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier();
});

// Doctor Provider
final doctorProvider = StateNotifierProvider<DoctorNotifier, DoctorState>((ref) {
  return DoctorNotifier();
});

// Emergency Provider
final emergencyProvider = Provider((ref) => EmergencyController());

// Notification Provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

// Pharmacy Provider
final pharmacyProvider =
    StateNotifierProvider.autoDispose<PharmacyNotifier, PharmacyState>((ref) {
  return PharmacyNotifier();
});

// Report Provider
final reportProvider = Provider((ref) => ReportController());

// Change Password Provider
final changePasswordProvider = StateNotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>((ref) {
  final notifier = ChangePasswordNotifier();
  ref.onDispose(() => notifier.disposeControllers());
  return notifier;
});
