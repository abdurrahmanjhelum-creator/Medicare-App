import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/services/token_service.dart';
import '../../../../../core/services/api_service.dart';
import '../widgets/profile_header.dart';
import '../widgets/personal_information.dart';
import 'edit_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _patientName = "Loading...";
  String _patientEmail = "";
  String _patientPhone = "";
  String _patientDob = "";
  String _patientAddress = "";
  String _patientId = "12345678";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    try {
      // Fetch from backend API
      final response = await ApiService.get(
        endpoint: '/patient-dashboard/profile',
        auth: true,
      );

      final userData = response['data']?['user'] ?? response['user'];
      final patientData = response['data']?['patient'] ?? response['patient'];

      // Fetch fallback values before setState
      final fallbackName = await TokenService.getUserName();
      final fallbackEmail = await TokenService.getUserEmail();
      final fallbackUserId = await TokenService.getUserId();

      if (mounted) {
        setState(() {
          _patientName = userData?['name'] ?? fallbackName ?? "Patient";
          _patientEmail = userData?['email'] ?? fallbackEmail ?? "";
          _patientPhone = userData?['phone'] ?? "";
          _patientId = userData?['id'] ?? fallbackUserId ?? "12345678";
          
          // Format DOB from backend
          if (patientData?['dob'] != null) {
            final dob = DateTime.parse(patientData['dob']);
            _patientDob = '${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
          }
          
          _patientAddress = patientData?['address'] ?? "Not provided";
          _isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to token service if API fails
      final name = await TokenService.getUserName();
      final email = await TokenService.getUserEmail();
      final userId = await TokenService.getUserId();
      
      if (mounted) {
        setState(() {
          _patientName = name ?? "Patient";
          _patientEmail = email ?? "";
          _patientId = userId ?? "12345678";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              name: _patientName,
              role: "Patient",
              medicalId: "MED-$_patientId",
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  PersonalInformation(
                    email: _patientEmail,
                    phone: _patientPhone,
                    dob: _patientDob,
                    address: _patientAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildProfileOption(
                    icon: Icons.edit_outlined,
                    title: "Edit Profile",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditScreen()),
                      );

                      if (result == true) {
                        _loadPatientData();
                      }
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  _buildProfileOption(
                    icon: Icons.lock_outline,
                    title: "Change Password",
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.changePassword),
                  ),
                  _buildProfileOption(
                    icon: Icons.logout_outlined,
                    title: "Logout",
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.primaryGreen),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
