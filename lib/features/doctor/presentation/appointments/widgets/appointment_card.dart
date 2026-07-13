// Appointment Card Widget - Doctor Side
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/appointment_model.dart';
import '../../../../patient/presentation/waitting/screens/waiting_screen.dart';
import '../../../../patient/presentation/video/screens/video_call_screen.dart';
import '../../../../patient/presentation/video/screens/appointment_completed_screen.dart';

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
                backgroundImage: appointment.patientImage.isNotEmpty 
                  ? NetworkImage(appointment.patientImage) 
                  : null,
                child: appointment.patientImage.isEmpty ? const Icon(Icons.person) : null,
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
                  appointment.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(appointment.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          
          // Appointment type & Info
          Row(
            children: [
              Icon(
                appointment.type == 'Video Call' ? Icons.video_call : Icons.location_on,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppDimensions.spacing8),
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
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacing12),
                decoration: BoxDecoration(
                color: AppColors.primaryBlue.withAlpha((0.05 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius8),
                border: Border.all(color: AppColors.primaryBlue.withAlpha((0.1 * 255).round())),
              ),
              child: Text(
                'Note: ${appointment.patientNotes}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppDimensions.spacing16),

          // Status specific actions based on workflow
          if (appointment.status.toLowerCase() == 'pending')
            // Upcoming tab: Only Confirm and Cancel buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onStatusUpdate('confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onStatusUpdate('cancelled'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.errorRed),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.errorRed)),
                  ),
                ),
              ],
            )
          else if (appointment.status.toLowerCase() == 'confirmed')
            // Confirmed tab: Only Join Consultation button
            _buildJoinButton(context)
          else if (appointment.status.toLowerCase() == 'completed')
            // Completed tab: Read-only, show Add Diagnosis button if no diagnosis
            if (appointment.diagnosis == null || appointment.diagnosis!.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onAddDiagnosis,
                        icon: const Icon(Icons.add_moderator, size: 18),
                        label: const Text('Add Diagnosis'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

          // Diagnosis aur prescription display for completed
          if (appointment.diagnosis != null && appointment.diagnosis!.isNotEmpty) ...[
            const Divider(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diagnosis:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(appointment.diagnosis!, style: const TextStyle(fontSize: 14)),
                if (appointment.prescription != null && appointment.prescription!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Prescription:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(appointment.prescription!, style: const TextStyle(fontSize: 14)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleJoinFlow(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_outlined, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Join Consultation",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _handleJoinFlow(BuildContext context) {
    // Requirement 10: Prevent joining cancelled, expired, or completed appointments
    final status = appointment.status.toLowerCase();
    if (status == 'cancelled' || status == 'completed') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot join ${appointment.status} appointment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Only allow video call for confirmed appointments
    if (status != 'confirmed' && status != 'upcoming') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm the appointment first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final now = DateTime.now();
    DateTime startTime;
    DateTime endTime;

    try {
      String timeStr = appointment.time.toUpperCase()
          .replaceAll('AM', ' AM')
          .replaceAll('PM', ' PM')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      
      List<String> parts = timeStr.split(RegExp(r'[-–—]'));
      
      DateTime parseSingleTime(String s) {
        s = s.trim();
        DateFormat format = s.contains('AM') || s.contains('PM') 
            ? DateFormat("h:mm a") 
            : DateFormat("HH:mm");
        DateTime p = format.parse(s);
        return DateTime(now.year, now.month, now.day, p.hour, p.minute);
      }

      startTime = parseSingleTime(parts.first);

      if (parts.length > 1) {
        endTime = parseSingleTime(parts.last);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }
      } else {
        endTime = startTime.add(const Duration(minutes: 30));
      }
    } catch (e) {
      startTime = now;
      endTime = now.add(const Duration(minutes: 30));
    }

    final pApp = appointment.toAppointmentModel();

    if (now.isBefore(startTime)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WaitingScreen(appointment: pApp)),
      );
    } else if (now.isAfter(endTime)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppointmentCompletedScreen(appointment: pApp)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoCallScreen(appointment: pApp)),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'upcoming':
        return AppColors.primaryGreen;
      case 'completed':
        return AppColors.successGreen;
      case 'cancelled':
        return AppColors.errorRed;
      case 'pending':
        return AppColors.warningOrange;
      default:
        return AppColors.textSecondary;
    }
  }
}
