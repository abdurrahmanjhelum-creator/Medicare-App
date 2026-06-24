// Appointment Card Widget - Appointment card widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final Function(String) onStatusUpdate;
  final VoidCallback onAddDiagnosis;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onStatusUpdate,
    required this.onAddDiagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
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
          // Patient info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(appointment.patientImage),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      '${appointment.date} at ${appointment.time}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(appointment.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          
          // Appointment type
          Row(
            children: [
              Icon(
                appointment.type == 'Video Call' ? Icons.video_call : Icons.location_on,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.spacing4),
              Text(
                appointment.type,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          // Patient notes
          if (appointment.patientNotes != null && appointment.patientNotes!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing12),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              ),
              child: Text(
                'Note: ${appointment.patientNotes}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ],
          
          // Diagnosis aur prescription
          if (appointment.diagnosis != null) ...[
            const SizedBox(height: AppDimensions.spacing12),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                color: AppColors.successGreen.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diagnosis:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                  Text(
                    appointment.diagnosis!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (appointment.prescription != null) ...[
                    const SizedBox(height: AppDimensions.spacing8),
                    const Text(
                      'Prescription:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successGreen,
                      ),
                    ),
                    Text(
                      appointment.prescription!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          
          // Action buttons
          if (appointment.status == 'pending' || appointment.status == 'confirmed') ...[
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onStatusUpdate('confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onStatusUpdate('cancelled'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorRed,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAddDiagnosis,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
                    ),
                    child: const Text('Add Diagnosis'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.primaryGreen;
      case 'completed':
        return AppColors.successGreen;
      case 'cancelled':
        return AppColors.errorRed;
      case 'pending':
      default:
        return AppColors.warningOrange;
    }
  }
}
