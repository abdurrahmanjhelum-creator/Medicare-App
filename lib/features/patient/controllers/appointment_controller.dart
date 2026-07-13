import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/refresh_backoff.dart';
import '../../../core/services/token_service.dart';
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
  final RefreshBackoff _backoff = RefreshBackoff();
  Timer? _refreshTimer;
  bool _isFetching = false;

  AppointmentNotifier()
      : super(
          AppointmentState(
            upcomingAppointments: [],
            completedAppointments: [],
          ),
        ) {
    fetchAppointments();
    _startPolling();
  }

  void _startPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_backoff.currentInterval, (timer) {
      fetchAppointments(silent: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  // Fetch appointments from backend
  Future<void> fetchAppointments({bool silent = false}) async {
    if (_isFetching) return;

    // Security check: Only fetch if the user is a patient
    final role = await TokenService.getUserRole();
    if (role != 'patient') {
      return; 
    }

    _isFetching = true;

    if (!silent) state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/appointments',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'appointments');
      final allAppointments =
          list.map((app) => AppointmentModel.fromJson(app)).toList();
      
      final upcoming = allAppointments
          .where((a) {
            final s = a.status.toLowerCase();
            return s == 'upcoming' ||
                s == 'pending' ||
                s == 'confirmed' ||
                s == 'rescheduled';
          })
          .toList();
      
      final completed = allAppointments
          .where((a) {
            final s = a.status.toLowerCase();
            return s == 'completed' ||
                s == 'cancelled' ||
                s == 'rejected';
          })
          .toList();

      state = state.copyWith(
        upcomingAppointments: upcoming,
        completedAppointments: completed,
        isLoading: false,
        error: null,
      );
      _backoff.recordSuccess();
    } catch (e) {
      _backoff.recordFailure();
      // Handle "Insufficient permissions" silently to avoid log spam if role changes
      if (e.toString().contains('permissions')) {
        _refreshTimer?.cancel(); // Stop polling if we shouldn't be here
        return;
      }
      
      if (!silent) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    } finally {
      _isFetching = false;
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
    return cancelAppointmentWithReason(appointmentId, 'Cancelled by patient');
  }

  // Cancel appointment with body
  Future<bool> cancelAppointmentWithReason(String appointmentId, String reason) async {
    try {
      await ApiService.delete(
        endpoint: '/appointments/cancel',
        auth: true,
        body: {
          'appointmentId': appointmentId,
          'reason': reason,
        },
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
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier();
});
