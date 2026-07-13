// Doctor Dashboard Screen - Doctor ka main dashboard screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/appointment_controller.dart';
import '../../../models/appointment_model.dart';
import '../widgets/dashboard_stats_card.dart';
import '../widgets/earnings_chart.dart';
import '../widgets/recent_appointments_list.dart';
import '../widgets/doctor_header.dart';
import 'manage_slots_screen.dart';

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
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadDashboardData();
      ref.read(doctorAppointmentProvider.notifier).loadAppointments();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for pending notification
    final appointmentState = ref.watch(doctorAppointmentProvider);
    if (appointmentState.pendingNotification != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAppointmentTimeNotification(appointmentState.pendingNotification!);
      });
    }
  }

  void _showAppointmentTimeNotification(DoctorAppointmentModel appointment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00A67E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time, color: Color(0xFF00A67E)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Appointment Time Arrived',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your appointment time has arrived. Please join the consultation.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient: ${appointment.patientName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Time: ${appointment.time}'),
                  Text('Type: ${appointment.type}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(doctorAppointmentProvider.notifier).clearNotification();
              Navigator.pop(context);
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(doctorAppointmentProvider.notifier).clearNotification();
              Navigator.pop(context);
              // Navigate to appointments screen
              Navigator.pushNamed(context, '/doctor-appointments');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A67E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Go to Appointments', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(dashboardProvider.notifier).refresh();
            await ref.read(doctorAppointmentProvider.notifier).loadAppointments();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  DoctorHeader(
                    doctorName: dashboardState.doctorName ?? 'Doctor',
                    onNotificationTap: () =>
                        Navigator.pushNamed(context, AppRoutes.doctorNotifications),
                    onProfileTap: () =>
                        Navigator.pushNamed(context, AppRoutes.doctorProfile),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Loading indicator
                  if (dashboardState.isLoading && dashboardState.dashboardData == null)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),

                  // Error message
                  if (dashboardState.error != null && dashboardState.dashboardData == null)
                    Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${dashboardState.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.errorRed),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.read(dashboardProvider.notifier).loadDashboardData(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),

                  // Dashboard content
                  if (dashboardState.dashboardData != null) ...[
                    // Stats cards
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppDimensions.spacing16,
                      mainAxisSpacing: AppDimensions.spacing16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.1,
                      children: [
                        DashboardStatsCard(
                          title: 'Total Appointments',
                          value: dashboardState.dashboardData!.totalAppointments.toString(),
                          icon: FontAwesomeIcons.calendarCheck,
                          color: AppColors.primaryBlue,
                        ),
                        DashboardStatsCard(
                          title: "Today's",
                          value: dashboardState.dashboardData!.todaysAppointmentsCount.toString(),
                          icon: FontAwesomeIcons.calendarDay,
                          color: AppColors.primaryGreen,
                        ),
                        DashboardStatsCard(
                          title: 'Upcoming',
                          value: dashboardState.dashboardData!.upcomingAppointments.toString(),
                          icon: FontAwesomeIcons.clock,
                          color: AppColors.warningOrange,
                        ),
                        DashboardStatsCard(
                          title: 'Completed',
                          value: dashboardState.dashboardData!.completedAppointments.toString(),
                          icon: FontAwesomeIcons.circleCheck,
                          color: AppColors.successGreen,
                        ),
                        DashboardStatsCard(
                          title: 'Cancelled',
                          value: dashboardState.dashboardData!.cancelledAppointments.toString(),
                          icon: FontAwesomeIcons.calendarXmark,
                          color: AppColors.errorRed,
                        ),
                        DashboardStatsCard(
                          title: 'Total Patients',
                          value: dashboardState.dashboardData!.totalPatients.toString(),
                          icon: FontAwesomeIcons.users,
                          color: Colors.purple,
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
                              Expanded(
                                child: Column(
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppDimensions.spacing12),
                              Expanded(
                                child: Column(
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
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

                    // Manage Time Slots button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageSlotsScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.access_time),
                        label: const Text(
                          'Manage Time Slots',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                          ),
                        ),
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
                    const SizedBox(height: AppDimensions.spacing24),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
