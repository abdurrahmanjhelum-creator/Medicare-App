import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/appointment_model.dart';
import '../../../controllers/appointment_controller.dart';
import '../widgets/waiting_header.dart';
import '../widgets/waiting_status_section.dart';
import '../widgets/waiting_card.dart';
import '../widgets/waiting_instructions.dart';
import '../../video/screens/appointment_completed_screen.dart';

class WaitingScreen extends ConsumerWidget {
  final AppointmentModel appointment;

  const WaitingScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the appointments state to get real-time updates
    final appointmentState = ref.watch(appointmentProvider);
    
    // Find the latest version of this appointment in the state
    final latestAppointment = appointmentState.upcomingAppointments.followedBy(appointmentState.completedAppointments)
        .firstWhere((a) => a.id == appointment.id, orElse: () => appointment);

    final status = latestAppointment.status.toLowerCase();
    
    // Requirement: If doctor cancels, rejects or completes, redirect patient immediately
    if (status == 'cancelled' || status == 'completed' || status == 'rejected') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppointmentCompletedScreen(appointment: latestAppointment)),
          );
        }
      });
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // Header Widget
          WaitingHeader(
            title: "Waiting Room",
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                   
                  // Status Section (Icon + Text)
                  WaitingStatusSection(doctorName: latestAppointment.doctorName),
                  
                  const SizedBox(height: 30),

                  // Waiting Cards (Time Info and Timer)
                  WaitingCard(appointment: latestAppointment),
                  
                  const SizedBox(height: 24),
                  
                  // Instruction Box Widget
                  const WaitingInstructions(),
                  
                  const SizedBox(height: 30),
                  
                  // Bottom Back Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Back to Appointments",
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
