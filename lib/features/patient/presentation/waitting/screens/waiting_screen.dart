import 'package:flutter/material.dart';
import '../../../models/appointment_model.dart';
import '../widgets/waiting_header.dart';
import '../widgets/waiting_status_section.dart';
import '../widgets/waiting_card.dart';
import '../widgets/waiting_instructions.dart';

class WaitingScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const WaitingScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
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
                  WaitingStatusSection(doctorName: appointment.doctorName),
                  
                  const SizedBox(height: 30),

                  // Waiting Cards (Time Info and Timer)
                  WaitingCard(appointment: appointment),
                  
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
