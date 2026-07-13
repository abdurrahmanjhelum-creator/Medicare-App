import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/patient/controllers/home_controller.dart';
import '../../features/patient/controllers/appointment_controller.dart';
import '../../features/patient/controllers/doctor_controller.dart';
import '../../features/patient/controllers/emergency_controller.dart';
import '../../features/patient/controllers/notification_controller.dart';
import '../../features/patient/controllers/pharmacy_controller.dart';
import '../../features/patient/controllers/report_controller.dart';
import '../../features/patient/controllers/change_password_controller.dart';
import '../../features/patient/controllers/review_controller.dart';
import '../../features/patient/controllers/chat_controller.dart';
import '../../features/patient/controllers/medical_record_controller.dart';

// Home Provider
final homeProvider = ChangeNotifierProvider.autoDispose((ref) {
  return HomeController();
});

// Appointment Provider - Added autoDispose to prevent background calls when not on screen
final appointmentProvider =
    StateNotifierProvider.autoDispose<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier();
});

// Doctor Provider
final doctorProvider = StateNotifierProvider.autoDispose<DoctorNotifier, DoctorState>((ref) {
  return DoctorNotifier();
});

// Emergency Provider
final emergencyProvider =
    StateNotifierProvider.autoDispose<EmergencyNotifier, EmergencyState>((ref) {
  return EmergencyNotifier();
});

// Notification Provider
final notificationProvider =
    StateNotifierProvider.autoDispose<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

// Pharmacy Provider
final pharmacyProvider =
    StateNotifierProvider.autoDispose<PharmacyNotifier, PharmacyState>((ref) {
  return PharmacyNotifier();
});

// Report Provider
final reportProvider =
    StateNotifierProvider.autoDispose<ReportNotifier, ReportState>((ref) {
  return ReportNotifier();
});

// Change Password Provider
final changePasswordProvider = StateNotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>((ref) {
  final notifier = ChangePasswordNotifier();
  ref.onDispose(() => notifier.disposeControllers());
  return notifier;
});

// Review Provider
final reviewProvider =
    StateNotifierProvider.autoDispose<ReviewNotifier, ReviewState>((ref) {
  return ReviewNotifier();
});

// Chat Provider
final patientChatProvider =
    StateNotifierProvider.autoDispose<PatientChatNotifier, PatientChatState>((ref) {
  return PatientChatNotifier();
});

// Medical Record Provider
final patientMedicalRecordProvider =
    StateNotifierProvider.autoDispose<PatientMedicalRecordNotifier, PatientMedicalRecordState>((ref) {
  return PatientMedicalRecordNotifier();
});
