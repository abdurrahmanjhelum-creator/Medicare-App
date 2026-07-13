// Notification Card Widget - Notification card widget
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final DoctorNotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  Color _parseColor(String colorStr, Color fallback) {
    try {
      String hex = colorStr.replaceAll('#', '').trim();
      if (hex.isEmpty) return fallback;
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = _parseColor(notification.iconColor, AppColors.primaryGreen);
    final Color bgColor = notification.isRead 
        ? AppColors.white 
        : _parseColor(notification.backgroundColor, const Color(0xFFF3F4F6));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconColor.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
              ),
              child: Icon(
                _getIcon(notification.icon),
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    notification.createdAt,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            Column(
              children: [
                if (!notification.isRead)
                  Container(
                    width: 10,
                    height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
                const SizedBox(height: AppDimensions.spacing8),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  color: AppColors.error,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'calendar':
        return Icons.calendar_today;
      case 'star':
        return Icons.star;
      case 'payment':
        return Icons.payment;
      case 'appointment':
        return Icons.event;
      case 'review':
        return Icons.rate_review;
      default:
        return Icons.notifications;
    }
  }
}
