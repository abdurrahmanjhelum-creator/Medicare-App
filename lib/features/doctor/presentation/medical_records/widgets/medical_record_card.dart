// Medical Record Card Widget - Medical record card widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/medical_record_model.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecordModel record;
  final VoidCallback onUpdate;

  const MedicalRecordCard({
    super.key,
    required this.record,
    required this.onUpdate,
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.createdAt,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: onUpdate,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing12),
          
          // Doctor name
          Text(
            'Dr. ${record.doctorName}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          
          // Diagnosis
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha((0.1 * 255).round()),
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
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  record.diagnosis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          
          // Prescription
          if (record.prescription.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prescription:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    record.prescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
          ],
          
          // Notes
          if (record.notes.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              decoration: BoxDecoration(
                          color: AppColors.warningOrange.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warningOrange,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    record.notes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
          ],
          
          // Attachments
          if (record.attachments.isNotEmpty) ...[
            const Text(
              'Attachments:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Wrap(
              spacing: AppDimensions.spacing8,
              runSpacing: AppDimensions.spacing8,
              children: record.attachments.map((attachment) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing8,
                  ),
                  decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.attach_file,
                        size: 16,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: AppDimensions.spacing4),
                      Text(
                        attachment.split('/').last,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
