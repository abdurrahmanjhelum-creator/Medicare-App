// Recent Appointments List Widget - Recent appointments list widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/dashboard_model.dart';

class RecentAppointmentsList extends StatelessWidget {
  final List<AppointmentStats> appointments;

  const RecentAppointmentsList({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text('No recent appointments'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
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
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryGreen,
                ),
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
                    color: appointment.status == 'completed'
                      ? AppColors.successGreen.withAlpha((0.1 * 255).round())
                      : appointment.status == 'pending'
                        ? AppColors.warningOrange.withAlpha((0.1 * 255).round())
                        : AppColors.textSecondary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: appointment.status == 'completed'
                        ? AppColors.successGreen
                        : appointment.status == 'pending'
                            ? AppColors.warningOrange
                            : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
