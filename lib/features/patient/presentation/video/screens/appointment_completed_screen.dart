import 'package:flutter/material.dart';
import 'package:medicare/core/services/token_service.dart';
import '../../../models/appointment_model.dart';
import 'add_review_screen.dart';

class AppointmentCompletedScreen extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCompletedScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenService.getUserRole(),
      builder: (context, snapshot) {
        final isDoctor = snapshot.data == 'doctor';
        
        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A67E).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Color(0xFF00A67E),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        isDoctor ? "Consultation Completed" : "Appointment Completed",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D212E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isDoctor 
                          ? "Your session with ${appointment.doctorName}"
                          : "Your appointment with Dr. ${appointment.doctorName}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "has been successfully completed",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.person, isDoctor ? "Patient: ${appointment.doctorName}" : appointment.doctorName),
                            const Divider(height: 24),
                            _buildInfoRow(
                              Icons.medical_services,
                              isDoctor ? "Online Consultation" : appointment.specialization,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.access_time, appointment.time),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.location_on, appointment.location),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      if (!isDoctor) ...[
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReviewScreen(appointment: appointment),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A67E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              "Give Review & Rating",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF00A67E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            isDoctor ? "Back to Dashboard" : "Back to Appointments",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A67E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00A67E), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1D212E)),
          ),
        ),
      ],
    );
  }
}
