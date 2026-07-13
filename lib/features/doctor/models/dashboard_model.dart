import 'appointment_model.dart';

// Dashboard Model - Robust implementation for Real Backend Data
class DashboardModel {
  final int totalPatients;
  final int totalAppointments;
  final int upcomingAppointments;
  final int completedAppointments;
  final int cancelledAppointments;
  final int pendingAppointments;
  final int todaysAppointmentsCount;
  final double totalEarnings;
  final double todayEarnings;
  final int thisWeekAppointments;
  final List<DoctorAppointmentModel> recentAppointments;
  final List<EarningStats> earningsChart;

  const DashboardModel({
    required this.totalPatients,
    required this.totalAppointments,
    required this.upcomingAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
    required this.pendingAppointments,
    required this.todaysAppointmentsCount,
    required this.totalEarnings,
    required this.todayEarnings,
    required this.thisWeekAppointments,
    required this.recentAppointments,
    required this.earningsChart,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    // Robust parsing to handle different backend naming conventions
    return DashboardModel(
      totalPatients: json['totalPatients'] ?? json['patientsCount'] ?? 0,
      totalAppointments: json['totalAppointments'] ?? json['appointmentsCount'] ?? 0,
      upcomingAppointments: json['upcomingAppointments'] ?? json['upcomingCount'] ?? 0,
      completedAppointments: json['completedAppointments'] ?? json['completedCount'] ?? 0,
      cancelledAppointments: json['cancelledAppointments'] ?? json['cancelledCount'] ?? 0,
      pendingAppointments: json['pendingAppointments'] ?? json['pendingCount'] ?? 0,
      todaysAppointmentsCount: json['todaysAppointmentsCount'] ?? json['todayCount'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? json['earnings'] ?? 0).toDouble(),
      todayEarnings: (json['todayEarnings'] ?? json['todayEarning'] ?? 0).toDouble(),
      thisWeekAppointments: json['thisWeekAppointments'] ?? json['weekCount'] ?? 0,
      recentAppointments: json['recentAppointments'] != null
          ? (json['recentAppointments'] as List)
              .map((e) => DoctorAppointmentModel.fromJson(e))
              .toList()
          : [],
      earningsChart: json['earningsChart'] != null
          ? (json['earningsChart'] as List)
              .map((e) => EarningStats.fromJson(e))
              .toList()
          : [],
    );
  }
}

class EarningStats {
  final String date;
  final double amount;

  const EarningStats({
    required this.date,
    required this.amount,
  });

  factory EarningStats.fromJson(Map<String, dynamic> json) {
    return EarningStats(
      date: json['date'] ?? json['day'] ?? '',
      amount: (json['amount'] ?? json['value'] ?? 0).toDouble(),
    );
  }
}
