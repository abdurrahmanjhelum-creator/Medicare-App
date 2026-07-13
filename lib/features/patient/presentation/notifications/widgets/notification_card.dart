import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: notification.isRead
            ? null
            : Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.2),
                width: 1,
              ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notification.iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(notification.icon, color: notification.iconColor, size: 20),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              notification.time,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                } else if (value == 'read') {
                  onTap();
                }
              },
              itemBuilder: (context) => [
                if (!notification.isRead)
                  const PopupMenuItem(
                    value: 'read',
                    child: Text('Mark as read'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
        onTap: !notification.isRead ? onTap : null,
      ),
    );
  }
}
