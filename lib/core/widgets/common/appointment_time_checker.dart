import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicare/features/patient/models/appointment_model.dart';
import 'package:medicare/features/patient/presentation/bottom_layout/appointment_dialog.dart';
import 'package:medicare/features/patient/presentation/waitting/screens/waiting_screen.dart';
import 'package:medicare/features/patient/presentation/video/screens/video_call_screen.dart';
import 'package:medicare/features/patient/presentation/video/screens/appointment_completed_screen.dart';

class AppointmentTimeChecker extends StatefulWidget {
  final List<AppointmentModel> appointments;

  const AppointmentTimeChecker({super.key, required this.appointments});

  @override
  State<AppointmentTimeChecker> createState() => _AppointmentTimeCheckerState();
}

class _AppointmentTimeCheckerState extends State<AppointmentTimeChecker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDialog();
    });
  }

  // Robust Time Parsing Logic
  Map<String, DateTime>? _getTimes(String timeStr) {
    try {
      // Normalize: "10:00AM" -> "10:00 AM", remove extra spaces
      String normalized = timeStr.toUpperCase()
          .replaceAll('AM', ' AM')
          .replaceAll('PM', ' PM')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      
      List<String> parts = normalized.split('-');
      DateTime now = DateTime.now();

      DateTime parseSingle(String s) {
        s = s.trim();
        try {
          return DateFormat("h:mm a").parse(s); // Try "10:00 AM"
        } catch (_) {
          return DateFormat("HH:mm").parse(s); // Try "22:00"
        }
      }

      DateTime startParsed = parseSingle(parts.first);
      DateTime startTime = DateTime(now.year, now.month, now.day, startParsed.hour, startParsed.minute);
      
      DateTime endTime;
      if (parts.length > 1) {
        DateTime endParsed = parseSingle(parts.last);
        endTime = DateTime(now.year, now.month, now.day, endParsed.hour, endParsed.minute);
        // Handle overnight appointments
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }
      } else {
        // Default 30 min duration
        endTime = startTime.add(const Duration(minutes: 30));
      }

      return {'start': startTime, 'end': endTime};
    } catch (e) {
      debugPrint("Time Parsing Error: $e");
      return null;
    }
  }

  void _checkAndShowDialog() {
    final now = DateTime.now();

    for (var appointment in widget.appointments) {
      final times = _getTimes(appointment.time);
      if (times == null) continue;

      DateTime startTime = times['start']!;
      DateTime endTime = times['end']!;

      // Dialog tabhi dikhayen jab appointment start hone wali ho ya chal rahi ho
      final diffFromStart = startTime.difference(now).inMinutes;
      if (diffFromStart >= -30 && diffFromStart <= 30) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AppointmentDialog(
              appointment: appointment,
              onTap: () {
                final clickTime = DateTime.now();
                Navigator.pop(context);

                // CORRECT LOGIC
                if (clickTime.isBefore(startTime)) {
                  // Current < Start
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaitingScreen(appointment: appointment)),
                  );
                } else if (!clickTime.isAfter(endTime)) {
                  // Start <= Current <= End
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoCallScreen(appointment: appointment)),
                  );
                } else {
                  // Current > End
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppointmentCompletedScreen(appointment: appointment)),
                  );
                }
              },
            ),
          );
        }
        break; 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
