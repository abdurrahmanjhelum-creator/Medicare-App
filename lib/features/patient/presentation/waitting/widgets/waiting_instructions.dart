import 'package:flutter/material.dart';

class WaitingInstructions extends StatelessWidget {
  const WaitingInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "Please wait until the scheduled time. You'll be automatically redirected when the meeting is ready to start.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF475569),
          height: 1.4,
        ),
      ),
    );
  }
}
