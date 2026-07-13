import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/core/constants/app_colors.dart';
import '../../../../../core/services/token_service.dart';

class WaitingStatusSection extends ConsumerWidget {
  final String doctorName;

  const WaitingStatusSection({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: TokenService.getUserRole(),
      builder: (context, snapshot) {
        final isDoctor = snapshot.data == 'doctor';
        final title = isDoctor ? "Waiting for Patient" : "You're Too Early!";
        final subtitlePrefix = isDoctor ? "Your patient is not yet in the room.\nThe session with " : "Your meeting with ";
        final subtitleSuffix = isDoctor ? "\nwill begin shortly." : "\nwill begin at:";

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
            Text(
              title,
              style: const TextStyle(
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
                    TextSpan(text: subtitlePrefix),
                    TextSpan(
                      text: doctorName,
                      style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: subtitleSuffix),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
