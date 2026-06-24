// Doctor Appointment Controller - Doctor appointments state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/appointment_model.dart';

// Appointment State
class DoctorAppointmentState {
  final bool isLoading;
  final String? error;
  final List<DoctorAppointmentModel> appointments;
  final int selectedTab; // 0: Upcoming, 1: Completed, 2: Cancelled

  DoctorAppointmentState({
    this.isLoading = false,
    this.error,
    this.appointments = const [],
    this.selectedTab = 0,
  });

  DoctorAppointmentState copyWith({
    bool? isLoading,
    String? error,
    List<DoctorAppointmentModel>? appointments,
    int? selectedTab,
  }) {
    return DoctorAppointmentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      appointments: appointments ?? this.appointments,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

// Appointment Notifier
class DoctorAppointmentNotifier extends StateNotifier<DoctorAppointmentState> {
  DoctorAppointmentNotifier() : super(DoctorAppointmentState());

  // Appointments load karein
  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API se data fetch karein
      final response = await ApiService.get(
        endpoint: '/appointments/doctor/my-appointments',
        auth: true,
      );
      
      // API response se appointments list create karein
      final appointmentsList = (response['data'] as List)
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList();
      
      state = state.copyWith(
        isLoading: false,
        appointments: appointmentsList,
      );
    } catch (e) {
      // If API fails or there are no appointments, show empty list (no dummy data)
      state = state.copyWith(
        isLoading: false,
        appointments: [],
        error: null,
      );
    }
  }

  // Tab change karein
  void changeTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  // Appointment status update karein
  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      // API call karein status update ke liye
      await ApiService.patch(
        endpoint: '/appointments/$appointmentId/status',
        body: {'status': status},
        auth: true,
      );
      
      final updatedAppointments = state.appointments.map((apt) {
        if (apt.id == appointmentId) {
          return DoctorAppointmentModel(
            id: apt.id,
            patientId: apt.patientId,
            patientName: apt.patientName,
            patientImage: apt.patientImage,
            date: apt.date,
            time: apt.time,
            type: apt.type,
            status: status,
            patientNotes: apt.patientNotes,
            diagnosis: apt.diagnosis,
            prescription: apt.prescription,
          );
        }
        return apt;
      }).toList();
      
      state = state.copyWith(appointments: updatedAppointments);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Diagnosis aur prescription add karein
  Future<void> addDiagnosis(
    String appointmentId,
    String diagnosis,
    String prescription,
  ) async {
    try {
      // API call karein
      await ApiService.patch(
        endpoint: '/appointments/$appointmentId/diagnosis',
        body: {
          'diagnosis': diagnosis,
          'prescription': prescription,
        },
        auth: true,
      );
      
      final updatedAppointments = state.appointments.map((apt) {
        if (apt.id == appointmentId) {
          return DoctorAppointmentModel(
            id: apt.id,
            patientId: apt.patientId,
            patientName: apt.patientName,
            patientImage: apt.patientImage,
            date: apt.date,
            time: apt.time,
            type: apt.type,
            status: 'completed',
            patientNotes: apt.patientNotes,
            diagnosis: diagnosis,
            prescription: prescription,
          );
        }
        return apt;
      }).toList();
      
      state = state.copyWith(appointments: updatedAppointments);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Appointment Provider
final doctorAppointmentProvider =
    StateNotifierProvider<DoctorAppointmentNotifier, DoctorAppointmentState>(
        (ref) {
  return DoctorAppointmentNotifier();
});
