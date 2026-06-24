// Doctor Appointments Screen - Doctor appointments screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/appointment_controller.dart';
import '../widgets/appointment_card.dart';
import '../../../models/appointment_model.dart';
import '../widgets/appointment_tabs.dart';

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
    Future.microtask(() => ref.read(doctorAppointmentProvider.notifier).loadAppointments());
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(doctorAppointmentProvider);

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
