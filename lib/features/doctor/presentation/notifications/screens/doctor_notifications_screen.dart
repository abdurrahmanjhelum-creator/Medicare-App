// Doctor Notifications Screen - Doctor notifications screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';

class DoctorNotificationsScreen extends ConsumerStatefulWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  ConsumerState<DoctorNotificationsScreen> createState() => _DoctorNotificationsScreenState();
}

class _DoctorNotificationsScreenState extends ConsumerState<DoctorNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Notifications load karein
    Future.microtask(() => ref.read(doctorNotificationProvider.notifier).loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(doctorNotificationProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notificationState.unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(doctorNotificationProvider.notifier).markAllAsRead();
              },
              child: const Text(
                'Mark all as read',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
        ],
      ),
      body: notificationState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notificationState.error != null
              ? Center(
                  child: Text(
                    'Error: ${notificationState.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : notificationState.notifications.isEmpty
                  ? const Center(
                      child: Text('No notifications'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
                      itemCount: notificationState.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notificationState.notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            ref.read(doctorNotificationProvider.notifier).markAsRead(notification.id);
                          },
                          onDelete: () {
                            ref.read(doctorNotificationProvider.notifier).deleteNotification(notification.id);
                          },
                        );
                      },
                    ),
    );
  }
}
