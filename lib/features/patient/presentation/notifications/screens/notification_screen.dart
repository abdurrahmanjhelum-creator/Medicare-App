import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/common/header.dart';
import '../../../../../core/widgets/common/back_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  void _markAllAsRead(BuildContext context, WidgetRef ref) {
    ref.read(notificationProvider.notifier).markAllAsRead();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications marked as read"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notifications = notificationState.notifications;

    return Scaffold(
      body: Column(
        children: [
          DoctorListHeader(
            title: "Notifications",
            shortText: "Stay updated with your health",
            showSearch: false,
            leading: BackToLoginButton(
              onTap: () => Navigator.pop(context),
              text: "Back",
            ),
            trailing: GestureDetector(
              onTap: () => _markAllAsRead(context, ref),
              child: const Text(
                "Mark all",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            firstColor: AppColors.primaryGreen,
            secondColor: AppColors.secondaryGreen,
          ),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text("No notifications yet"))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return NotificationCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        time: item.time,
                        icon: item.icon,
                        iconColor: item.iconColor,
                        iconBgColor: item.iconBgColor,
                        isRead: item.isRead,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
