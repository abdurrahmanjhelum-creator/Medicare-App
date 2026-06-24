import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentState {
  final int selectedTab;
  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> completedAppointments;
  final bool isLoading;
  final String? error;

  AppointmentState({
    this.selectedTab = 0,
    required this.upcomingAppointments,
    required this.completedAppointments,
    this.isLoading = false,
    this.error,
  });

  AppointmentState copyWith({
    int? selectedTab,
    List<AppointmentModel>? upcomingAppointments,
    List<AppointmentModel>? completedAppointments,
    bool? isLoading,
    String? error,
  }) {
    return AppointmentState(
      selectedTab: selectedTab ?? this.selectedTab,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      completedAppointments:
          completedAppointments ?? this.completedAppointments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AppointmentNotifier extends StateNotifier<AppointmentState> {
  AppointmentNotifier()
      : super(
          AppointmentState(
            upcomingAppointments: [],
            completedAppointments: [],
          ),
        ) {
    fetchAppointments();
  }

  // Fetch appointments from backend
  Future<void> fetchAppointments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/appointments',
        auth: true,
      );

      final data = response['data'] ?? response;
      if (data is List) {
        final allAppointments = data.map((app) => AppointmentModel.fromJson(app)).toList();
        final upcoming = allAppointments.where((a) => a.status == 'Upcoming' || a.status == 'pending' || a.status == 'confirmed').toList();
        final completed = allAppointments.where((a) => a.status == 'Completed' || a.status == 'cancelled').toList();
        
        state = state.copyWith(
          upcomingAppointments: upcoming,
          completedAppointments: completed,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // Load dummy data on error
      _loadDummyData();
    }
  }

  // Book new appointment
  Future<bool> bookAppointment(Map<String, dynamic> appointmentData) async {
    try {
      await ApiService.post(
        endpoint: '/appointments',
        body: appointmentData,
        auth: true,
      );
      await fetchAppointments();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Cancel appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      await ApiService.delete(
        endpoint: '/appointments/cancel',
        auth: true,
      );
      await fetchAppointments();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  void addAppointment(AppointmentModel appointment) {
    state = state.copyWith(
      upcomingAppointments: [...state.upcomingAppointments, appointment],
    );
  }

  void _loadDummyData() {
    state = state.copyWith(
      upcomingAppointments: [
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg",
          doctorName: "Dr. Sarah Johnson",
          specialization: "Cardiologist",
          time: "10:30 AM - 11:00 AM",
          type: "Video Call",
          location: "Online",
          status: "Upcoming",
        ),
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/successful-medical-team_329181-9252.jpg",
          doctorName: "Dr. Michael Chen",
          specialization: "Dermatologist",
          time: "02:00 PM - 02:30 PM",
          type: "In-Person",
          location: "City Hospital",
          status: "Upcoming",
        ),
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/handsome-young-male-doctor-with-stethoscope-standing-against-blue-background_662251-343.jpg",
          doctorName: "Dr. David Smith",
          specialization: "Orthopedic",
          time: "04:30 PM - 05:00 PM",
          type: "In-Person",
          location: "Med Central",
          status: "Upcoming",
        ),
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/doctor-with-stethoscope-around-his-neck_1150-18456.jpg",
          doctorName: "Dr. Robert Brown",
          specialization: "Neurologist",
          time: "09:00 AM - 09:30 AM",
          type: "Video Call",
          location: "Online",
          status: "Upcoming",
        ),
      ],
      completedAppointments: [
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/smiling-female-doctor-holding-clipboard-looking-camera_107420-65158.jpg",
          doctorName: "Dr. Emily White",
          specialization: "General Physician",
          time: "09:00 AM - 09:30 AM",
          type: "In-Person",
          location: "West Wing Clinic",
          status: "Completed",
        ),
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/doctor-with-stethoscope-around-his-neck_1150-18456.jpg",
          doctorName: "Dr. James Wilson",
          specialization: "Neurologist",
          time: "11:30 AM - 12:00 PM",
          type: "Video Call",
          location: "Online",
          status: "Completed",
        ),
        const AppointmentModel(
          doctorimage: "https://img.freepik.com/free-photo/portrait-smiling-handsome-male-doctor-man_1303-21443.jpg",
          doctorName: "Dr. Thomas Miller",
          specialization: "Oncologist",
          time: "03:00 PM - 03:30 PM",
          type: "In-Person",
          location: "Central Hospital",
          status: "Completed",
        ),
      ],
    );
  }
}
