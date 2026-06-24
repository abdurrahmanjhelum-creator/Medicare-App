import 'package:flutter/material.dart';
import 'package:medicare/core/constants/app_colors.dart';

class WaitingStatusSection extends StatelessWidget {
  final String doctorName;

  const WaitingStatusSection({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF7ED),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled,
            color: Color(0xFFFDBA74),
            size: 50,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "You're Too Early!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5),
              children: [
                const TextSpan(text: "Your meeting with "),
                TextSpan(
                  text: doctorName,
                  style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: "\nwill begin at:"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
