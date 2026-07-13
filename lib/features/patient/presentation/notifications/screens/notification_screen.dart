import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/common/header.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../models/notification_model.dart';
import '../../../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notificationNotifier = ref.read(notificationProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          DoctorListHeader(
            title: "Notifications",
            shortText: "Stay updated with your appointments",
            showSearch: false,
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notificationNotifier.fetchNotifications(),
              child: notificationState.isLoading && notificationState.notifications.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                  : notificationState.error != null && notificationState.notifications.isEmpty
                      ? _buildErrorState(notificationState.error!, notificationNotifier)
                      : notificationState.notifications.isEmpty
                          ? _buildEmptyState()
                          : _buildNotificationList(notificationState.notifications, notificationNotifier),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, NotificationNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Error loading notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.fetchNotifications(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications, NotificationNotifier notifier) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${notifications.length} Notifications',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: () => notifier.markAllAsRead(),
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(color: AppColors.primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationCard(
                notification: notification,
                onTap: () => notifier.markAsRead(notification.id),
                onDelete: () => notifier.deleteNotification(notification.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
