import 'package:flutter/material.dart';
import 'package:medicare/features/patient/models/appointment_model.dart';
import '../../../../core/services/token_service.dart';

class AppointmentDialog extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;

  const AppointmentDialog({
    super.key,
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return FutureBuilder<String?>(
      future: TokenService.getUserRole(),
      builder: (context, snapshot) {
        final isDoctor = snapshot.data == 'doctor';
        final mainTitle = isDoctor ? "Appointment Time Arrived" : "Video Consultation Ready";
        final subTitle = isDoctor 
            ? "Your appointment time has arrived. Please join the consultation." 
            : "Your appointment is now starting";

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 4,
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.95,
              minWidth: 320,
            ),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                border: Border.all(color: const Color(0xff00A278), width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xff00A278),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mainTitle,
                              style: TextStyle(
                                color: const Color(0xff0A1929),
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 18 : 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subTitle,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xffE2F7F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xff00A278),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isDoctor ? "Patient: ${appointment.doctorName}" : appointment.doctorName,
                                style: const TextStyle(
                                  color: Color(0xff0A1929),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isDoctor ? "Online Consultation" : appointment.specialization,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Scheduled for ${appointment.time}",
                          style: const TextStyle(
                            color: Color(0xff4A5568),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00A278),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Join Call",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
