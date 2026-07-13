// Doctor Dashboard Controller - 100% Backend Integration
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/refresh_backoff.dart';
import '../models/dashboard_model.dart';

class DashboardState {
  final bool isLoading;
  final String? error;
  final DashboardModel? dashboardData;
  final String? doctorName;
  final Map<String, dynamic>? doctorProfile;

  DashboardState({
    this.isLoading = false,
    this.error,
    this.dashboardData,
    this.doctorName,
    this.doctorProfile,
  });

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    DashboardModel? dashboardData,
    String? doctorName,
    Map<String, dynamic>? doctorProfile,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dashboardData: dashboardData ?? this.dashboardData,
      doctorName: doctorName ?? this.doctorName,
      doctorProfile: doctorProfile ?? this.doctorProfile,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    _scheduleAutoRefresh();
  }

  Timer? _autoRefreshTimer;
  bool _isFetching = false;
  final RefreshBackoff _backoff = RefreshBackoff();

  void _scheduleAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer(_backoff.currentInterval, () async {
      await loadDashboardData(silent: true);
      _scheduleAutoRefresh();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> loadDashboardData({bool silent = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    if (!silent) state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await Future.wait([
        ApiService.get(endpoint: '/doctor-dashboard/stats', auth: true),
        ApiService.get(endpoint: '/doctor-dashboard/profile', auth: true),
      ]);

      final statsData = ApiService.unwrapMap(results[0]);
      final profileData = ApiService.unwrapMap(results[1]);

      // Handle nested user/doctor structure from backend
      final user = (profileData['user'] ?? {}) as Map<String, dynamic>;
      final doctorName = (user['name'] ?? 'Doctor').toString();

      // DashboardModel factory handles the rest
      final dashboardData = DashboardModel.fromJson(statsData);

      _backoff.recordSuccess();
      state = state.copyWith(
        isLoading: false,
        dashboardData: dashboardData,
        doctorName: doctorName,
        doctorProfile: profileData,
        error: null,
      );
    } catch (e) {
      _backoff.recordFailure();
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

  Future<void> refresh() async {
    await loadDashboardData();
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
