import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../../../models/appointment_model.dart';
import '../../video/screens/video_call_screen.dart';

class WaitingCard extends StatefulWidget {
  final AppointmentModel appointment;

  const WaitingCard({super.key, required this.appointment});

  @override
  State<WaitingCard> createState() => _WaitingCardState();
}

class _WaitingCardState extends State<WaitingCard> {
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _calculateInitialSeconds();
    _startTimer();
  }

  void _calculateInitialSeconds() {
    try {
      String startTimePart = widget.appointment.time.split(RegExp(r'[-–—]')).first.trim();
      DateFormat format;
      if (startTimePart.toUpperCase().contains('AM') ||
          startTimePart.toUpperCase().contains('PM')) {
        format = DateFormat("h:mm a");
      } else {
        format = DateFormat("HH:mm");
      }

      DateTime parsedTime = format.parse(startTimePart);
      DateTime now = DateTime.now();
      DateTime appointmentDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      final differenceInSeconds = appointmentDateTime.difference(now).inSeconds;
      setState(() {
        _secondsRemaining = differenceInSeconds > 0 ? differenceInSeconds : 0;
      });
    } catch (e) {
      _secondsRemaining = 0;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        _timer?.cancel();
        _autoNavigateToCall();
      }
    });
  }

  void _autoNavigateToCall() {
    if (mounted) {
      // Requirement 5: Automatically allow entry into the Video Call Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(appointment: widget.appointment),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatFullTimer(int seconds) {
    if (seconds <= 0) return "0h 0m 0s";
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours}h ${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.03 * 255).round()),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Color(0xFF089B73),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Time",
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  Text(
                    widget.appointment.time,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F6F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                "Meeting starts in",
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              Text(
                _formatFullTimer(_secondsRemaining),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF089B73),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
