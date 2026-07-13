import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String patientName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.patientName,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamualaikum,",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                patientName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B3D),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: onNotificationTap,
            ),
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                backgroundColor: AppColors.primaryGreen,
                radius: 25,
                child: Text(
                  patientName.isNotEmpty ? patientName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
