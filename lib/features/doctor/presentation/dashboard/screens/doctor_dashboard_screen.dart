// Doctor Dashboard Screen - Doctor ka main dashboard screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../controllers/dashboard_controller.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/earnings_chart.dart';
import '../widgets/recent_appointments_list.dart';
import '../widgets/doctor_header.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends ConsumerState<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Dashboard data load karein
    Future.microtask(() => ref.read(dashboardProvider.notifier).loadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                DoctorHeader(
                  doctorName: dashboardState.doctorName ?? 'Doctor',
                  onNotificationTap: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                  onProfileTap: () =>
                      Navigator.pushNamed(context, AppRoutes.doctorProfile),
                ),
                const SizedBox(height: AppDimensions.spacing24),

                // Loading indicator
                if (dashboardState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // Error message
                if (dashboardState.error != null)
                  Center(
                    child: Text(
                      'Error: ${dashboardState.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // Dashboard content
                if (!dashboardState.isLoading && dashboardState.dashboardData != null) ...[
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatsCard(
                          title: 'Total Patients',
                          value: dashboardState.dashboardData!.totalPatients.toString(),
                          icon: FontAwesomeIcons.users,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: DashboardStatsCard(
                          title: 'Appointments',
                          value: dashboardState.dashboardData!.totalAppointments.toString(),
                          icon: FontAwesomeIcons.calendarCheck,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatsCard(
                          title: 'Completed',
                          value: dashboardState.dashboardData!.completedAppointments.toString(),
                          icon: FontAwesomeIcons.circleCheck,
                          color: AppColors.successGreen,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      Expanded(
                        child: DashboardStatsCard(
                          title: 'Pending',
                          value: dashboardState.dashboardData!.pendingAppointments.toString(),
                          icon: FontAwesomeIcons.clock,
                          color: AppColors.warningOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Earnings section
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Earnings Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Earnings',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Rs. ${dashboardState.dashboardData!.totalEarnings.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Rs. ${dashboardState.dashboardData!.todayEarnings.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        // Earnings chart
                        EarningsChart(
                          earningsData: dashboardState.dashboardData!.earningsChart,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Recent appointments
                  const Text(
                    'Recent Appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  RecentAppointmentsList(
                    appointments: dashboardState.dashboardData!.recentAppointments,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
