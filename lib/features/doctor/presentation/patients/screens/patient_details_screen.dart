// Patient Details Screen - Doctor Side
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../models/patient_model.dart';

class PatientDetailsScreen extends StatelessWidget {
  final DoctorPatientModel patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: patient.profileImage.isNotEmpty
                        ? NetworkImage(patient.profileImage)
                        : null,
                    child: patient.profileImage.isEmpty
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    patient.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (patient.userId.isNotEmpty)
                    Text(
                      'Patient ID: ${patient.userId.substring(patient.userId.length > 8 ? patient.userId.length - 8 : 0).toUpperCase()}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniInfo('Age', patient.age.isNotEmpty ? patient.age : 'N/A'),
                      _buildMiniInfo('Gender', patient.gender.isNotEmpty ? patient.gender : 'N/A'),
                      _buildMiniInfo('Blood', patient.bloodGroup.isNotEmpty ? patient.bloodGroup : 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.doctorMedicalRecords,
                              arguments: {
                                'patientId': patient.id.isNotEmpty ? patient.id : patient.userId,
                                'patientName': patient.name,
                              },
                            );
                          },
                          icon: const Icon(Icons.medical_information_outlined),
                          label: const Text('Records'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.doctorChat,
                              arguments: {
                                'patientId': patient.userId,
                                'patientName': patient.name,
                              },
                            );
                          },
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Chat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Details'),
            _buildInfoCard([
              _buildInfoRow(Icons.phone, 'Phone', patient.phone.isNotEmpty ? patient.phone : 'N/A'),
              _buildInfoRow(Icons.email, 'Email', patient.email.isNotEmpty ? patient.email : 'N/A'),
              _buildInfoRow(Icons.location_on, 'Address', patient.address.isNotEmpty ? patient.address : 'N/A'),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Medical History'),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingHorizontal),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
              ),
              child: Text(
                patient.medicalHistory.isEmpty ? 'No medical history recorded.' : patient.medicalHistory,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    );
  }
}
