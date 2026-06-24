import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:medicare/core/widgets/common/header.dart';
import 'package:medicare/core/widgets/common/profile_image.dart';
import 'package:medicare/core/widgets/form/full_name_field.dart';
import 'package:medicare/core/widgets/form/email_text_field.dart';
import 'package:medicare/core/widgets/form/phone_number_field.dart';
import 'package:medicare/core/widgets/form/date_of_birth_field.dart';
import 'package:medicare/core/widgets/form/login_button.dart';
import 'package:medicare/core/widgets/common/back_button.dart';
import '../../../../../core/services/api_service.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final resp = await ApiService.get(endpoint: '/patient-dashboard/profile', auth: true);
      final data = resp['data'] as Map<String, dynamic>?;
      final user = data?['user'] as Map<String, dynamic>?;
      final patient = data?['patient'] as Map<String, dynamic>?;

      _nameController.text = user?['name'] ?? '';
      _emailController.text = user?['email'] ?? '';
      _phoneController.text = user?['phone'] ?? '';
      _dobController.text = patient?['dob'] ?? '';
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            DoctorListHeader(
              title: "Edit Profile",
              shortText: "Update your personal information",
              showSearch: false,
              leading: BackToLoginButton(
                onTap: () => Navigator.pop(context),
                text: "Back",
              ),
            ),

            const SizedBox(height: 30),

            // Profile Image Section
            Column(
              children: [
                ProfileImage(
                  imageUrl: "", // Pass the current image URL if any
                  size: 110,
                  isEditable: true,
                  onEdit: () {
                    // TODO: Implement image picker logic
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  "Change Profile Picture",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Form Fields using existing widgets from core/widgets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FullNameTextField(controller: _nameController),
                  const SizedBox(height: 20),
                  EmailTextField(controller: _emailController),
                  const SizedBox(height: 20),
                  PhoneNumberTextField(controller: _phoneController),
                  const SizedBox(height: 20),
                  DOBTextField(controller: _dobController),
                  const SizedBox(height: 40),

                  // Action Button
                  LoginButton(
                    height: 55,
                    width: double.infinity,
                    text: "Save Changes",
                    onTap: _saving ? () {} : () => _onSave(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);
    try {
      final body = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
      };

      await ApiService.put(endpoint: '/patients/profile', body: body, auth: true);

      // Show confirmation dialog
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
