import 'dart:async';
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
  Timer? _timer;
  final Set<String> _notifiedAppointments = {};

  @override
  void initState() {
    super.initState();
    // Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDialog();
    });
    // Periodic check every 30 seconds to ensure real-time popup
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkAndShowDialog();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Map<String, DateTime>? _getTimes(String timeStr) {
    try {
      String normalized = timeStr.toUpperCase()
          .replaceAll('AM', ' AM')
          .replaceAll('PM', ' PM')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      
      List<String> parts = normalized.split(RegExp(r'[-–—]'));
      DateTime now = DateTime.now();

      DateTime parseSingle(String s) {
        s = s.trim();
        try {
          return DateFormat("h:mm a").parse(s);
        } catch (_) {
          return DateFormat("HH:mm").parse(s);
        }
      }

      DateTime startParsed = parseSingle(parts.first);
      DateTime startTime = DateTime(now.year, now.month, now.day, startParsed.hour, startParsed.minute);
      
      DateTime endTime;
      if (parts.length > 1) {
        DateTime endParsed = parseSingle(parts.last);
        endTime = DateTime(now.year, now.month, now.day, endParsed.hour, endParsed.minute);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }
      } else {
        endTime = startTime.add(const Duration(minutes: 30));
      }

      return {'start': startTime, 'end': endTime};
    } catch (e) {
      return null;
    }
  }

  void _checkAndShowDialog() {
    if (!mounted) return;
    final now = DateTime.now();

    for (var appointment in widget.appointments) {
      final times = _getTimes(appointment.time);
      if (times == null) continue;

      DateTime startTime = times['start']!;
      DateTime endTime = times['end']!;

      // Don't show again if already notified in this session
      final appointmentKey = "${appointment.id}_${appointment.time}";
      if (_notifiedAppointments.contains(appointmentKey)) continue;

      // Logic: Show popup when current time is within 1 minute of start time, or if it just started
      // We check if now is between [startTime - 1min] and [startTime + 2min]
      if (now.isAfter(startTime.subtract(const Duration(minutes: 1))) && 
          now.isBefore(startTime.add(const Duration(minutes: 2)))) {
        
        _notifiedAppointments.add(appointmentKey);
        
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AppointmentDialog(
              appointment: appointment,
              onTap: () {
                Navigator.pop(context);
                final clickTime = DateTime.now();
                if (clickTime.isBefore(startTime)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WaitingScreen(appointment: appointment)),
                  );
                } else if (!clickTime.isAfter(endTime)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoCallScreen(appointment: appointment)),
                  );
                } else {
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
