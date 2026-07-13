import 'package:flutter/material.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forget_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/new_password_screen.dart';
import '../../features/auth/presentation/screens/doctor_register_screen.dart';
import '../../features/auth/presentation/screens/patient_register_screen.dart';
import '../../features/patient/presentation/bottom_layout/bottom_navbar.dart';
import '../../features/patient/presentation/pharmacy/screens/pharmacy_screen.dart';
import '../../features/patient/presentation/profile/screens/edit_screen.dart';
import '../../features/patient/presentation/profile/screens/profile_screen.dart';
import '../../features/patient/presentation/notifications/screens/notification_screen.dart';
import '../../features/patient/presentation/reports/screens/reports_screen.dart';
import '../../features/patient/presentation/emergency/screens/emergency_screen.dart';
import '../../features/patient/presentation/doctors/screens/doctor_list_screen.dart';
import '../../features/patient/presentation/doctors/screens/doctor_details_screen.dart';
import '../../features/patient/presentation/doctors/screens/patient_chat_screen.dart';
import '../../features/patient/presentation/profile/screens/change_password_screen.dart';
import '../../features/patient/presentation/profile/screens/prescriptions_screen.dart';
import '../../features/patient/presentation/appointments/screens/appointment_screen.dart';
import '../../features/patient/models/doctor_model.dart';
import '../../features/patient/presentation/book/screens/booking_screen.dart';
import '../../features/doctor/presentation/bottom_layout/doctor_bottom_nav.dart';
import '../../features/doctor/presentation/dashboard/screens/doctor_dashboard_screen.dart';
import '../../features/doctor/presentation/appointments/screens/doctor_appointments_screen.dart';
import '../../features/doctor/presentation/patients/screens/doctor_patients_screen.dart';
import '../../features/doctor/presentation/medical_records/screens/medical_records_screen.dart';
import '../../features/doctor/presentation/chat/screens/doctor_chat_screen.dart';
import '../../features/doctor/presentation/reviews/screens/doctor_reviews_screen.dart';
import '../../features/doctor/presentation/profile/screens/doctor_profile_screen.dart';
import '../../features/doctor/presentation/notifications/screens/doctor_notifications_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String doctorRegister = '/doctor-register';
  static const String patientRegister = '/patient-register';
  static const String mainLayout = '/main-layout';
  static const String pharmacy = '/pharmacy';
  static const String editProfile = '/edit-profile';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String prescriptions = '/prescriptions';
  static const String emergency = '/emergency';
  static const String doctor = '/doctor';
  static const String doctorDetails = '/doctor-details';
  static const String patientChat = '/patient-chat';
  static const String changePassword = '/change-password';
  static const String appointment = '/appointment';
  static const String bookingScreen = '/booking';
  static const String doctorMainLayout = '/doctor-main-layout';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String doctorAppointments = '/doctor-appointments';
  static const String doctorPatients = '/doctor-patients';
  static const String doctorMedicalRecords = '/doctor-medical-records';
  static const String doctorChat = '/doctor-chat';
  static const String doctorReviews = '/doctor-reviews';
  static const String doctorProfile = '/doctor-profile';
  static const String doctorNotifications = '/doctor-notifications';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const Splashscreen(),
    onboarding: (context) => const OnboardingCarousel(),
    login: (context) => const Loginscreen(),
    register: (context) => const RegisterScreen(),
    forgetPassword: (context) => const Forgetscreen(),
    otp: (context) => const OtpVerificationScreen(),
    resetPassword: (context) => const Newpassword(),
    doctorRegister: (context) => const DoctorRegisterScreen(),
    patientRegister: (context) => const ARegisterScreen(),
    mainLayout: (context) => const MainLayout(),
    pharmacy: (context) => const PharmacyScreen(),
    editProfile: (context) => const EditScreen(),
    profile: (context) => const ProfileScreen(),
    notifications: (context) => const NotificationScreen(),
    reports: (context) => const LabReportsScreen(),
    prescriptions: (context) => const PrescriptionsScreen(),
    emergency: (context) => const EmergencyScreen(),
    doctor: (context) => const DoctorScreen(),
    doctorDetails: (context) {
      final doctor = ModalRoute.of(context)!.settings.arguments as DoctorModel;
      return DoctorDetailsScreen(doctor: doctor);
    },
    patientChat: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return PatientChatScreen(
        doctorId: args['doctorId'],
        doctorName: args['doctorName'],
      );
    },
    changePassword: (context) => const NewPasswordScreen(),
    appointment: (context) => const AppointmentScreen(),
    bookingScreen: (context) {
      final doctor = ModalRoute.of(context)!.settings.arguments as DoctorModel;
      return BookingScreen(doctor: doctor);
    },
    doctorMainLayout: (context) => const DoctorBottomNav(),
    doctorDashboard: (context) => const DoctorDashboardScreen(),
    doctorAppointments: (context) => const DoctorAppointmentsScreen(),
    doctorPatients: (context) => const DoctorPatientsScreen(),
    doctorMedicalRecords: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return MedicalRecordsScreen(
        patientId: args['patientId'],
        patientName: args['patientName'],
      );
    },
    doctorChat: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return DoctorChatScreen(
        patientId: args['patientId'],
        patientName: args['patientName'],
      );
    },
    doctorReviews: (context) => const DoctorReviewsScreen(),
    doctorProfile: (context) => const DoctorProfileScreen(),
    doctorNotifications: (context) => const DoctorNotificationsScreen(),
  };
}
