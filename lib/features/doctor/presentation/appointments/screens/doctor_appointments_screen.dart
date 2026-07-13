// Doctor Appointments Screen - Doctor appointments screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/appointment_controller.dart';
import '../widgets/appointment_card.dart';
import '../../../models/appointment_model.dart';
import '../widgets/appointment_tabs.dart';
import '../../../../patient/presentation/waitting/screens/waiting_screen.dart';
import '../../../../patient/presentation/video/screens/video_call_screen.dart';
import '../../../../patient/presentation/video/screens/appointment_completed_screen.dart';

class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  ConsumerState<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends ConsumerState<DoctorAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    // Appointments load karein
    Future.microtask(() {
      ref.read(doctorAppointmentProvider.notifier).loadAppointments();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for immediate notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorAppointmentProvider.notifier).checkImmediateNotifications();
    });
  }

  void _showAppointmentTimeNotification(DoctorAppointmentModel appointment, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00A67E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.access_time, color: Color(0xFF00A67E)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Appointment Reminder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient: ${appointment.patientName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Time: ${appointment.time}'),
                  Text('Type: ${appointment.type}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(doctorAppointmentProvider.notifier).clearNotification();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
          if (message.contains('arrived'))
            ElevatedButton(
              onPressed: () {
                ref.read(doctorAppointmentProvider.notifier).clearNotification();
                Navigator.pop(context);
                // Navigate to the appointment card action
                _handleJoinMeeting(appointment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A67E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Join Now', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  void _handleJoinMeeting(DoctorAppointmentModel appointment) {
    // Requirement 10: Prevent joining cancelled or completed appointments
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

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(doctorAppointmentProvider);

    // Show notification dialog when available
    if (appointmentState.pendingNotification != null && appointmentState.notificationMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAppointmentTimeNotification(
          appointmentState.pendingNotification!,
          appointmentState.notificationMessage!,
        );
        // Clear notification after showing
        ref.read(doctorAppointmentProvider.notifier).clearNotification();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          AppointmentTabs(
            selectedTab: appointmentState.selectedTab,
            onTabChanged: (index) {
              ref.read(doctorAppointmentProvider.notifier).changeTab(index);
            },
          ),
          const SizedBox(height: AppDimensions.spacing16),

          // Appointments list
          Expanded(
            child: appointmentState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : appointmentState.error != null
                    ? Center(
                        child: Text(
                          'Error: ${appointmentState.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : appointmentState.appointments.isEmpty
                        ? const Center(
                            child: Text('No appointments found'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.screenPaddingHorizontal,
                            ),
                            itemCount: appointmentState.appointments.length,
                            itemBuilder: (context, index) {
                              final appointment = appointmentState.appointments[index];
                              return AppointmentCard(
                                appointment: appointment,
                                onStatusUpdate: (status) {
                                  ref.read(doctorAppointmentProvider.notifier).updateAppointmentStatus(appointment.id, status);
                                },
                                onAddDiagnosis: () {
                                  _showDiagnosisDialog(context, appointment);
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  // Diagnosis dialog show karein
  void _showDiagnosisDialog(BuildContext context, DoctorAppointmentModel appointment) {
    final diagnosisController = TextEditingController();
    final prescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Diagnosis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            TextField(
              controller: prescriptionController,
              decoration: const InputDecoration(
                labelText: 'Prescription',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (diagnosisController.text.isNotEmpty && prescriptionController.text.isNotEmpty) {
                ref.read(doctorAppointmentProvider.notifier).addDiagnosis(
                  appointment.id,
                  appointment.patientId,
                  diagnosisController.text,
                  prescriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
