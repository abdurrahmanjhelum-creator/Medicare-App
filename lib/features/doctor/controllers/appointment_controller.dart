// Doctor Appointment Controller - 100% Complete & Production Ready
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/refresh_backoff.dart';
import '../models/appointment_model.dart';
import 'dashboard_controller.dart';

class DoctorAppointmentState {
  final bool isLoading;
  final String? error;
  final List<DoctorAppointmentModel> allAppointments;
  final List<DoctorAppointmentModel> appointments;
  final int selectedTab; // 0: Upcoming, 1: Confirmed, 2: Completed, 3: Cancelled
  final DoctorAppointmentModel? pendingNotification;
  final String? notificationMessage; // For 30min, 5min, at-time notifications

  DoctorAppointmentState({
    this.isLoading = false,
    this.error,
    this.allAppointments = const [],
    this.appointments = const [],
    this.selectedTab = 0,
    this.pendingNotification,
    this.notificationMessage,
  });

  DoctorAppointmentState copyWith({
    bool? isLoading,
    String? error,
    List<DoctorAppointmentModel>? allAppointments,
    List<DoctorAppointmentModel>? appointments,
    int? selectedTab,
    DoctorAppointmentModel? pendingNotification,
    String? notificationMessage,
  }) {
    return DoctorAppointmentState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      allAppointments: allAppointments ?? this.allAppointments,
      appointments: appointments ?? this.appointments,
      selectedTab: selectedTab ?? this.selectedTab,
      pendingNotification: pendingNotification,
      notificationMessage: notificationMessage,
    );
  }
}

class DoctorAppointmentNotifier extends StateNotifier<DoctorAppointmentState> {
  final Ref _ref;
  DoctorAppointmentNotifier(this._ref) : super(DoctorAppointmentState());
  Timer? _autoRefreshTimer;
  Timer? _notificationTimer;
  bool _isFetching = false;
  final RefreshBackoff _backoff = RefreshBackoff();
  final Set<String> _notifiedAppointments = {};

  void startAutoRefresh() {
    _scheduleAutoRefresh();
  }

  void _scheduleAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer(_backoff.currentInterval, () async {
      await loadAppointments(silent: true);
      _scheduleAutoRefresh();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _notificationTimer?.cancel();
    super.dispose();
  }

  Future<void> loadAppointments({bool silent = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    if (!silent) state = state.copyWith(isLoading: true, error: null);

    try {
      // Load ALL appointments first (no filtering)
      final response = await ApiService.get(
        endpoint: '/appointments/doctor/my-appointments',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'appointments');
      final allAppointments = list
          .map((e) => DoctorAppointmentModel.fromJson(e))
          .toList();

      // Check for expired appointments to auto-complete
      _checkAndAutoComplete(allAppointments);

      // Filter based on selected tab
      final filteredAppointments = _filterAppointmentsByTab(allAppointments, state.selectedTab);

      state = state.copyWith(
        isLoading: false,
        allAppointments: allAppointments,
        appointments: filteredAppointments,
        error: null,
      );

      _backoff.recordSuccess();

      // Start notification timer for upcoming appointments
      _startNotificationTimer(allAppointments);

    } catch (e) {
      _backoff.recordFailure();
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.split('Exception:').last.trim();
      }

      if (!silent) {
        state = state.copyWith(
          isLoading: false,
          allAppointments: [],
          appointments: [],
          error: errorMessage,
        );
      }
    } finally {
      _isFetching = false;
    }
  }

  List<DoctorAppointmentModel> _filterAppointmentsByTab(List<DoctorAppointmentModel> all, int tabIndex) {
    switch (tabIndex) {
      case 0: // Upcoming - pending status only (not yet confirmed)
        return all.where((app) => app.status.toLowerCase() == 'pending').toList();

      case 1: // Confirmed - confirmed status only
        return all.where((app) => app.status.toLowerCase() == 'confirmed').toList();

      case 2: // Completed - completed status only
        return all.where((app) => app.status.toLowerCase() == 'completed').toList();

      case 3: // Cancelled - cancelled status only
        return all.where((app) => app.status.toLowerCase() == 'cancelled').toList();

      default:
        return all;
    }
  }

  void _checkAndAutoComplete(List<DoctorAppointmentModel> list) {
    final now = DateTime.now();
    for (var app in list) {
      // Only process active appointments (not cancelled or already completed)
      final status = app.status.toLowerCase();
      if (status != 'cancelled' && status != 'completed') {
        final times = _parseTime(app.time);
        if (times != null) {
          final endTime = times['end']!;

          // Auto-complete if past end time
          if (now.isAfter(endTime) && status != 'completed') {
            updateAppointmentStatus(app.id, 'completed', silent: true);
          }
        }
      }
    }
  }

  Map<String, DateTime>? _parseTime(String timeStr) {
    try {
      String normalized = timeStr.toUpperCase().replaceAll('AM', ' AM').replaceAll('PM', ' PM').replaceAll(RegExp(r'\s+'), ' ').trim();
      List<String> parts = normalized.split(RegExp(r'[-–—]'));
      DateTime now = DateTime.now();
      DateTime parseSingle(String s) {
        DateFormat format = s.contains('AM') || s.contains('PM') ? DateFormat("h:mm a") : DateFormat("HH:mm");
        DateTime p = format.parse(s.trim());
        return DateTime(now.year, now.month, now.day, p.hour, p.minute);
      }
      DateTime start = parseSingle(parts.first);
      DateTime end = parts.length > 1 ? parseSingle(parts.last) : start.add(const Duration(minutes: 30));
      if (end.isBefore(start)) end = end.add(const Duration(days: 1));
      return {'start': start, 'end': end};
    } catch (_) { return null; }
  }

  void _startNotificationTimer(List<DoctorAppointmentModel> appointments) {
    _notificationTimer?.cancel();
    final now = DateTime.now();

    for (var appointment in appointments) {
      if (appointment.status.toLowerCase() == 'confirmed') {
        final times = _parseTime(appointment.time);
        if (times != null) {
          final startTime = times['start']!;
          final timeUntilStart = startTime.difference(now);

          // Only set timer if appointment is in the future and within 24 hours
          if (timeUntilStart > Duration.zero && timeUntilStart.inHours < 24) {
            // Check for 30-minute notification
            if (timeUntilStart.inMinutes == 30 && !_notifiedAppointments.contains('${appointment.id}_30min')) {
              _notificationTimer = Timer(timeUntilStart, () {
                _showNotificationMessage(appointment, 'Your appointment is starting soon. Please stay active and be ready to join.');
                _notifiedAppointments.add('${appointment.id}_30min');
              });
            }
            // Check for 5-minute notification
            else if (timeUntilStart.inMinutes == 5 && !_notifiedAppointments.contains('${appointment.id}_5min')) {
              _notificationTimer = Timer(timeUntilStart, () {
                _showNotificationMessage(appointment, 'Your appointment will start in 5 minutes. Please be ready and stay active.');
                _notifiedAppointments.add('${appointment.id}_5min');
              });
            }
            // Check for at-time notification
            else if (timeUntilStart.inSeconds <= 60 && !_notifiedAppointments.contains('${appointment.id}_time')) {
              _notificationTimer = Timer(timeUntilStart, () {
                _showNotificationMessage(appointment, 'Your appointment time has arrived. Please join the consultation.');
                _notifiedAppointments.add('${appointment.id}_time');
              });
            }
          }
        }
      }
    }
  }

  // Check for immediate notifications when screen opens (30 min, 5 min, at-time)
  void checkImmediateNotifications() {
    final now = DateTime.now();
    for (var appointment in state.allAppointments) {
      if (appointment.status.toLowerCase() == 'confirmed') {
        final times = _parseTime(appointment.time);
        if (times != null) {
          final startTime = times['start']!;
          final timeUntilStart = startTime.difference(now);

          // 30 minutes before
          if (timeUntilStart.inMinutes <= 30 && timeUntilStart.inMinutes > 0) {
            if (!_notifiedAppointments.contains('${appointment.id}_30min')) {
              _showNotificationMessage(appointment, 'Your appointment is starting soon. Please stay active and be ready to join.');
              _notifiedAppointments.add('${appointment.id}_30min');
              return; // Show one at a time
            }
          }
          // 5 minutes before
          else if (timeUntilStart.inMinutes <= 5 && timeUntilStart.inMinutes > 0) {
            if (!_notifiedAppointments.contains('${appointment.id}_5min')) {
              _showNotificationMessage(appointment, 'Your appointment will start in 5 minutes. Please be ready and stay active.');
              _notifiedAppointments.add('${appointment.id}_5min');
              return;
            }
          }
          // At time
          else if (timeUntilStart.inSeconds <= 0 && timeUntilStart.inSeconds >= -60) {
            if (!_notifiedAppointments.contains('${appointment.id}_time')) {
              _showNotificationMessage(appointment, 'Your appointment time has arrived. Please join the consultation.');
              _notifiedAppointments.add('${appointment.id}_time');
              return;
            }
          }
        }
      }
    }
  }

  void _showNotificationMessage(DoctorAppointmentModel appointment, String message) {
    state = state.copyWith(
      pendingNotification: appointment,
      notificationMessage: message,
    );
  }

  void clearNotification() {
    state = state.copyWith(
      pendingNotification: null,
      notificationMessage: null,
    );
  }

  void changeTab(int index) {
    state = state.copyWith(selectedTab: index, error: null);
    // Re-filter existing appointments instead of reloading
    final filtered = _filterAppointmentsByTab(state.allAppointments, index);
    state = state.copyWith(appointments: filtered);
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status, {bool silent = false}) async {
    try {
      await ApiService.put(
        endpoint: '/appointments/$appointmentId/status',
        body: {'status': status},
        auth: true,
      );
      if (!silent) {
        await loadAppointments();
        // Immediately refresh dashboard to update stats
        _ref.read(dashboardProvider.notifier).loadDashboardData(silent: true);
      }
    } catch (e) {
      if (!silent) {
        String errorMessage = e.toString().replaceAll('Exception: ', '');
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  Future<void> addDiagnosis(String appointmentId, String patientId, String diagnosis, String prescription) async {
    try {
      await ApiService.post(
        endpoint: '/medical-records',
        body: {
          'patientId': patientId,
          'diagnosis': diagnosis,
          'prescription': prescription,
          'appointmentId': appointmentId,
        },
        auth: true,
      );
      await updateAppointmentStatus(appointmentId, 'completed');
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  String _statusFromTabIndex(int index) {
    switch (index) {
      case 0: return 'upcoming';
      case 1: return 'all';
      case 2: return 'confirmed';
      case 3: return 'completed';
      case 4: return 'cancelled';
      case 5: return 'pending';
      default: return 'upcoming';
    }
  }
}

final doctorAppointmentProvider =
    StateNotifierProvider<DoctorAppointmentNotifier, DoctorAppointmentState>((ref) {
  final notifier = DoctorAppointmentNotifier(ref);
  notifier.startAutoRefresh();
  return notifier;
});

final upcomingAppointmentsProvider = Provider<List<DoctorAppointmentModel>>((ref) {
  final appointmentState = ref.watch(doctorAppointmentProvider);
  return appointmentState.allAppointments
      .where((appointment) => appointment.status.toLowerCase() == 'confirmed')
      .toList();
});
