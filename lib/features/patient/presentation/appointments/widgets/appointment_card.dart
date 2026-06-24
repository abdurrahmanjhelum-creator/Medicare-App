import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widgets/common/cached_image_widget.dart';
import '../../../models/appointment_model.dart';
import '../../waitting/screens/waiting_screen.dart';
import '../../video/screens/video_call_screen.dart';
import '../../video/screens/appointment_completed_screen.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorProfileImage(
                imageUrl: appointment.doctorimage,
                size: 50,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D212E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.specialization,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00A67E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  appointment.status,
                  style: const TextStyle(
                    color: Color(0xFF00A67E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today_outlined, "Today"),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, "${appointment.time} • ${appointment.type}"),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, appointment.location),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              DateTime startTime;
              DateTime endTime;

              try {
                // Normalize string: "10:00AM" -> "10:00 AM", replace different dashes
                String timeStr = appointment.time.toUpperCase()
                    .replaceAll('AM', ' AM')
                    .replaceAll('PM', ' PM')
                    .replaceAll(RegExp(r'\s+'), ' ')
                    .trim();
                
                // Handling formats like "10:00 AM - 10:30 AM" or "10:00 AM"
                List<String> parts = timeStr.split(RegExp(r'[-–—]'));
                
                DateTime parseSingleTime(String s) {
                  s = s.trim();
                  // Check if format is h:mm a (10:00 AM) or HH:mm (22:00)
                  DateFormat format = s.contains('AM') || s.contains('PM') 
                      ? DateFormat("h:mm a") 
                      : DateFormat("HH:mm");
                  DateTime p = format.parse(s);
                  return DateTime(now.year, now.month, now.day, p.hour, p.minute);
                }

                startTime = parseSingleTime(parts.first);

                if (parts.length > 1) {
                  endTime = parseSingleTime(parts.last);
                  // Handle overnight cases (e.g., 11:30 PM to 12:30 AM)
                  if (endTime.isBefore(startTime)) {
                    endTime = endTime.add(const Duration(days: 1));
                  }
                } else {
                  // If only start time is provided, assume 30 min duration
                  endTime = startTime.add(const Duration(minutes: 30));
                }
              } catch (e) {
                debugPrint("Error parsing appointment time: $e");
                startTime = now;
                endTime = now.add(const Duration(minutes: 30));
              }

              // REAL LOGIC IMPLEMENTATION
              if (now.isBefore(startTime)) {
                // 1. current time < appointment time -> Waiting Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingScreen(appointment: appointment)),
                );
              } else if (now.isAfter(endTime)) {
                // 3. current time > appointment end time -> Complete Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentCompletedScreen(appointment: appointment)),
                );
              } else {
                // 2. appointment time <= current time <= end time -> Video Screen
                // (This block is reached if not before start and not after end)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoCallScreen(appointment: appointment)),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_outlined, size: 20, color: Colors.black87),
                  SizedBox(width: 8),
                  Text(
                    "Video Call",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      ],
    );
  }
}
