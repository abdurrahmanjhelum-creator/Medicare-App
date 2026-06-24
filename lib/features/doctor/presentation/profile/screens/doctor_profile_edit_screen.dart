// Doctor Profile Edit Screen - edit doctor profile
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/services/api_service.dart';

class DoctorProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> initialUser;
  final Map<String, dynamic> initialDoctor;

  const DoctorProfileEditScreen({super.key, required this.initialUser, required this.initialDoctor});

  @override
  State<DoctorProfileEditScreen> createState() => _DoctorProfileEditScreenState();
}

class _DoctorProfileEditScreenState extends State<DoctorProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _specializationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _feeController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialUser['name'] ?? '');
    _emailController = TextEditingController(text: widget.initialUser['email'] ?? '');
    _phoneController = TextEditingController(text: widget.initialUser['phone'] ?? '');
    _specializationController = TextEditingController(text: widget.initialDoctor['specialization'] ?? '');
    _experienceController = TextEditingController(text: widget.initialDoctor['experience']?.toString() ?? '');
    _feeController = TextEditingController(text: widget.initialDoctor['fee']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: Column(
          children: [
            _buildTextField('Name', _nameController),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTextField('Email', _emailController, enabled: false),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTextField('Phone', _phoneController),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTextField('Specialization', _specializationController),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTextField('Experience', _experienceController),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTextField('Consultation Fee (Rs.)', _feeController),
            const SizedBox(height: AppDimensions.spacing24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                  ),
                ),
                child: _saving
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                    : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: AppDimensions.spacing8),
        TextField(controller: controller, enabled: enabled, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius12)))),
      ],
    );
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);
    try {
      final body = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'experience': int.tryParse(_experienceController.text) ?? 0,
        'fee': double.tryParse(_feeController.text) ?? 0.0,
      };

      await ApiService.put(endpoint: '/doctor-dashboard/profile', body: body, auth: true);

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Profile Updated'),
          content: const Text('Your profile edited'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }
}
