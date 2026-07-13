// Doctor Profile Screen - 100% Real Backend Data
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/services/token_service.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../controllers/dashboard_controller.dart';
import 'doctor_profile_edit_screen.dart';

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final profile = dashboardState.doctorProfile;
    final doctor = profile?['doctor'] ?? profile;
    final user = profile?['user'] ?? profile;

    final name = user?['name'] ?? 'Doctor';
    final email = user?['email'] ?? '';
    final phone = user?['phone'] ?? '';
    final spec = doctor?['specialization'] ?? 'General Physician';
    final exp = doctor?['experience']?.toString() ?? '0';
    final fee = doctor?['fee']?.toString() ?? '0';
    final imageUrl = user?['profileImage'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primaryGreen),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorProfileEditScreen(
                    initialUser: user as Map<String, dynamic>? ?? {},
                    initialDoctor: doctor as Map<String, dynamic>? ?? {},
                  ),
                ),
              );
              if (result == true) {
                ref.read(dashboardProvider.notifier).loadDashboardData();
              }
            },
          ),
        ],
      ),
      body: dashboardState.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primaryGreen.withAlpha(50),
                          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                          child: imageUrl.isEmpty
                              ? const Icon(Icons.person, size: 60, color: AppColors.primaryGreen)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          spec,
                          style: const TextStyle(fontSize: 16, color: AppColors.primaryGreen, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info Sections
                  _buildSectionTitle('Contact Information'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.email_outlined, 'Email', email),
                    _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
                  ]),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Professional Details'),
                  _buildInfoCard([
                    _buildInfoRow(Icons.history_edu, 'Experience', '$exp Years'),
                    _buildInfoRow(Icons.payments_outlined, 'Consultation Fee', 'Rs. $fee'),
                  ]),

                  const SizedBox(height: 32),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await TokenService.clearAll();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.02 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primaryGreen),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
