import 'package:flutter/material.dart';
import '../../../models/appointment_model.dart';

class WaitingInfoCard extends StatelessWidget {
  final AppointmentModel appointment;

  const WaitingInfoCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          // Date Row
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF089B73),
                size: 24,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date",
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  Text(
                    appointment.date ?? 'Date not set',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9)),
          ),
          // Time Row
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF089B73), size: 24),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Time",
                    style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                  ),
                  Text(
                    appointment.time,
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
        ],
      ),
    );
  }
}
