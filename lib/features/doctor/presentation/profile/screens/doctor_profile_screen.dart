// Doctor Profile Screen - Doctor profile screen
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/services/api_service.dart';
import 'doctor_profile_edit_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _feeController = TextEditingController();

  bool _loading = true;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _doctor;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: const NetworkImage(
                        'https://img.freepik.com/free-photo/doctor-with-stethoscope_1368-104.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  _buildReadOnlyField('Name', _user?['name'] ?? ''),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildReadOnlyField('Email', _user?['email'] ?? ''),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildReadOnlyField('Phone', _user?['phone'] ?? ''),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildReadOnlyField('Specialization', _doctor?['specialization'] ?? ''),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildReadOnlyField('Experience', _doctor?['experience']?.toString() ?? ''),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildReadOnlyField('Consultation Fee (Rs.)', _doctor?['fee']?.toString() ?? ''),
                  const SizedBox(height: AppDimensions.spacing24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileEditScreen(
                              initialUser: _user ?? {},
                              initialDoctor: _doctor ?? {},
                            ),
                          ),
                        );

                        if (result == true) {
                          _loadProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
            ),
            filled: !enabled,
            fillColor: !enabled ? AppColors.scaffoldBackground : null,
          ),
        ),
      ],
    );
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final resp = await ApiService.get(endpoint: '/doctor-dashboard/profile', auth: true);
      final data = resp['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      final doctor = data?['doctor'] as Map<String, dynamic>?;

      _user = user;
      _doctor = doctor;
      _nameController.text = user?['name'] ?? '';
      _emailController.text = user?['email'] ?? '';
      _phoneController.text = user?['phone'] ?? '';
      _specializationController.text = doctor?['specialization'] ?? '';
      _experienceController.text = doctor?['experience']?.toString() ?? '';
      _feeController.text = doctor?['fee']?.toString() ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      final body = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'experience': int.tryParse(_experienceController.text) ?? 0,
        'fee': double.tryParse(_feeController.text) ?? 0.0,
      };

      await ApiService.put(endpoint: '/doctor-dashboard/profile', body: body, auth: true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.03 * 255).round()),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
