// Recent Appointments List Widget - Doctor Side
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/appointment_model.dart';
import '../../appointments/widgets/appointment_card.dart';

class RecentAppointmentsList extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;

  const RecentAppointmentsList({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius12),
        ),
        child: const Center(
          child: Text(
            'No recent appointments',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: appointments.map((appointment) => AppointmentCard(
        appointment: appointment,
        onStatusUpdate: (status) {
          // Dashboard pe status update functionality agar chahiye toh yahan callback de sakte hain
        },
        onAddDiagnosis: () {
          // Dashboard se diagnosis add karne ke liye
        },
      )).toList(),
    );
  }
}
