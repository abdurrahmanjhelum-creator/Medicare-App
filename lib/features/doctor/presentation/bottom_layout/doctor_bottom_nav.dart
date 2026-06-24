// Doctor Bottom Navigation - Doctor bottom navigation bar
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/services/token_service.dart';
import '../dashboard/screens/doctor_dashboard_screen.dart';
import '../appointments/screens/doctor_appointments_screen.dart';
import '../patients/screens/doctor_patients_screen.dart';
import '../reviews/screens/doctor_reviews_screen.dart';
import '../profile/screens/doctor_profile_screen.dart';

class DoctorBottomNav extends ConsumerStatefulWidget {
  const DoctorBottomNav({super.key});

  @override
  ConsumerState<DoctorBottomNav> createState() => _DoctorBottomNavState();
}

class _DoctorBottomNavState extends ConsumerState<DoctorBottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final role = await TokenService.getUserRole();
        if (role != null && role != 'doctor' && mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
        }
      } catch (_) {}
    });
  }

  final List<Widget> _screens = [
    const DoctorDashboardScreen(),
    const DoctorAppointmentsScreen(),
    const DoctorPatientsScreen(),
    const DoctorReviewsScreen(),
    const DoctorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.1 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.calendar_today,
                  label: 'Appointments',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.people,
                  label: 'Patients',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.star,
                  label: 'Reviews',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
