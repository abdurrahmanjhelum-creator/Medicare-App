// Doctor Profile Edit Screen - 100% Comprehensive Backend Integration
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
  late final TextEditingController _phoneController;
  late final TextEditingController _specController;
  late final TextEditingController _qualController;
  late final TextEditingController _expController;
  late final TextEditingController _feeController;
  late final TextEditingController _clinicController;
  late final TextEditingController _addressController;
  late final TextEditingController _bioController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialUser['name'] ?? '');
    _phoneController = TextEditingController(text: widget.initialUser['phone'] ?? '');
    _specController = TextEditingController(text: widget.initialDoctor['specialization'] ?? '');
    _qualController = TextEditingController(text: widget.initialDoctor['qualification'] ?? '');
    _expController = TextEditingController(text: widget.initialDoctor['experience']?.toString() ?? '');
    _feeController = TextEditingController(text: widget.initialDoctor['fee']?.toString() ?? '');
    _clinicController = TextEditingController(text: widget.initialDoctor['clinic'] ?? '');
    _addressController = TextEditingController(text: widget.initialDoctor['clinicAddress'] ?? '');
    _bioController = TextEditingController(text: widget.initialDoctor['bio'] ?? '');
  }

  @override
  void dispose() {
    for (var c in [_nameController, _phoneController, _specController, _qualController, _expController, _feeController, _clinicController, _addressController, _bioController]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Professional Profile'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: Column(
          children: [
            _buildTextField('Full Name', _nameController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController, Icons.phone),
            const SizedBox(height: 16),
            _buildTextField('Specialization', _specController, Icons.medical_services),
            const SizedBox(height: 16),
            _buildTextField('Qualification', _qualController, Icons.school),
            const SizedBox(height: 16),
            _buildTextField('Experience (Years)', _expController, Icons.history_edu, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('Consultation Fee (Rs.)', _feeController, Icons.payments, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('Clinic Name', _clinicController, Icons.local_hospital),
            const SizedBox(height: 16),
            _buildTextField('Clinic Address', _addressController, Icons.location_on),
            const SizedBox(height: 16),
            _buildTextField('Bio / Description', _bioController, Icons.description, maxLines: 4),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saving ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);
    try {
      final body = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'specialization': _specController.text.trim(),
        'qualification': _qualController.text.trim(),
        'experience': int.tryParse(_expController.text) ?? 0,
        'fee': double.tryParse(_feeController.text) ?? 0.0,
        'clinic': _clinicController.text.trim(),
        'clinicAddress': _addressController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      await ApiService.put(endpoint: '/doctor-dashboard/profile', body: body, auth: true);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
