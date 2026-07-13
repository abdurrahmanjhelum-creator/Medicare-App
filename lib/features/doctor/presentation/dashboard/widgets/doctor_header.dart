// Doctor Header Widget - 100% Real Data
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/dashboard_controller.dart';

class DoctorHeader extends ConsumerWidget {
  final String doctorName;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;

  const DoctorHeader({
    super.key,
    required this.doctorName,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(dashboardProvider).doctorProfile;
    final imageUrl = profileData?['user']?['profileImage'] ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                doctorName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(FontAwesomeIcons.bell, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: imageUrl.isNotEmpty 
                    ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                    : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: imageUrl.isEmpty 
                  ? const Icon(FontAwesomeIcons.user, size: 20, color: AppColors.textPrimary)
                  : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
