// Dashboard Model - Doctor dashboard stats ka data model
class DashboardModel {
  final int totalPatients;
  final int totalAppointments;
  final int completedAppointments;
  final int pendingAppointments;
  final double totalEarnings;
  final double todayEarnings;
  final int thisWeekAppointments;
  final List<AppointmentStats> recentAppointments;
  final List<EarningStats> earningsChart;

  const DashboardModel({
    required this.totalPatients,
    required this.totalAppointments,
    required this.completedAppointments,
    required this.pendingAppointments,
    required this.totalEarnings,
    required this.todayEarnings,
    required this.thisWeekAppointments,
    required this.recentAppointments,
    required this.earningsChart,
  });

  // JSON se model create karne ke liye
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalPatients: json['totalPatients'] ?? 0,
      totalAppointments: json['totalAppointments'] ?? 0,
      completedAppointments: json['completedAppointments'] ?? 0,
      pendingAppointments: json['pendingAppointments'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      todayEarnings: (json['todayEarnings'] ?? 0).toDouble(),
      thisWeekAppointments: json['thisWeekAppointments'] ?? 0,
      recentAppointments: json['recentAppointments'] != null
          ? (json['recentAppointments'] as List)
              .map((e) => AppointmentStats.fromJson(e))
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

// Appointment Stats Model - Recent appointments ke liye
class AppointmentStats {
  final String patientName;
  final String date;
  final String time;
  final String status;

  const AppointmentStats({
    required this.patientName,
    required this.date,
    required this.time,
    required this.status,
  });

  factory AppointmentStats.fromJson(Map<String, dynamic> json) {
    return AppointmentStats(
      patientName: json['patientName'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

// Earning Stats Model - Earnings chart ke liye
class EarningStats {
  final String date;
  final double amount;

  const EarningStats({
    required this.date,
    required this.amount,
  });

  factory EarningStats.fromJson(Map<String, dynamic> json) {
    return EarningStats(
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}
