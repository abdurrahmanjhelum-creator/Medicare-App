// Doctor Dashboard Controller - Doctor dashboard state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/dashboard_model.dart';

// Dashboard State
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

// Dashboard Notifier
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState());

  // Dashboard data load karein
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API se data fetch karein
      // Fetch stats and profile from backend and combine into DashboardModel
      final statsResp = await ApiService.get(
        endpoint: '/doctor-dashboard/stats',
        auth: true,
      );

      final profileResp = await ApiService.get(
        endpoint: '/doctor-dashboard/profile',
        auth: true,
      );

      final profileData = profileResp['data'] as Map<String, dynamic>?;
      final doctorName = profileData != null ? (profileData['user']?['name'] ?? '') as String : null;

      final stats = statsResp['data'] as Map<String, dynamic>;

      // recentAppointments and earningsChart may not be provided by the backend yet;
      // keep them empty so UI can show skeletons instead of fake data.
      final dashboardData = DashboardModel(
        totalPatients: stats['totalPatients'] ?? 0,
        totalAppointments: stats['totalAppointments'] ?? 0,
        completedAppointments: stats['completedAppointments'] ?? 0,
        pendingAppointments: stats['pendingAppointments'] ?? 0,
        totalEarnings: (stats['totalEarnings'] ?? 0).toDouble(),
        todayEarnings: (stats['totalEarnings'] ?? 0).toDouble(),
        thisWeekAppointments: stats['totalAppointments'] ?? 0,
        recentAppointments: [],
        earningsChart: [],
      );

      state = state.copyWith(
        isLoading: false,
        dashboardData: dashboardData,
        doctorName: doctorName,
        doctorProfile: profileData,
      );
    } catch (e) {
      // Agar API fail ho jaye toh dummy data use karein
      await Future.delayed(const Duration(seconds: 1));
      
      final dummyData = DashboardModel(
        totalPatients: 156,
        totalAppointments: 234,
        completedAppointments: 198,
        pendingAppointments: 36,
        totalEarnings: 45600.0,
        todayEarnings: 1200.0,
        thisWeekAppointments: 28,
        recentAppointments: [
          const AppointmentStats(
            patientName: "Ahmed Khan",
            date: "2024-06-22",
            time: "10:00 AM",
            status: "completed",
          ),
          const AppointmentStats(
            patientName: "Fatima Ali",
            date: "2024-06-22",
            time: "11:30 AM",
            status: "pending",
          ),
          const AppointmentStats(
            patientName: "Usman Ahmed",
            date: "2024-06-21",
            time: "02:00 PM",
            status: "completed",
          ),
        ],
        earningsChart: [
          const EarningStats(date: "Mon", amount: 1500.0),
          const EarningStats(date: "Tue", amount: 1800.0),
          const EarningStats(date: "Wed", amount: 1200.0),
          const EarningStats(date: "Thu", amount: 2000.0),
          const EarningStats(date: "Fri", amount: 1700.0),
          const EarningStats(date: "Sat", amount: 900.0),
          const EarningStats(date: "Sun", amount: 600.0),
        ],
      );
      
      state = state.copyWith(
        isLoading: false,
        dashboardData: dummyData,
      );
    }
  }

  // Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }
}

// Dashboard Provider
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
