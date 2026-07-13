// Doctor Notification Controller - Doctor notifications state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../models/notification_model.dart';

// Notification State
class DoctorNotificationState {
  final bool isLoading;
  final String? error;
  final List<DoctorNotificationModel> notifications;
  final int unreadCount;

  DoctorNotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  DoctorNotificationState copyWith({
    bool? isLoading,
    String? error,
    List<DoctorNotificationModel>? notifications,
    int? unreadCount,
  }) {
    return DoctorNotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// Notification Notifier
class DoctorNotificationNotifier extends StateNotifier<DoctorNotificationState> {
  DoctorNotificationNotifier() : super(DoctorNotificationState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await ApiService.get(
        endpoint: '/notifications',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'notifications');
      final notificationsList = list
          .map((e) => DoctorNotificationModel.fromJson(e))
          .toList();
      final unread = notificationsList.where((n) => !n.isRead).length;

      state = state.copyWith(
        isLoading: false,
        notifications: notificationsList,
        unreadCount: unread,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.put(
        endpoint: '/notifications/mark-read',
        body: {'notificationId': notificationId},
        auth: true,
      );

      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return DoctorNotificationModel(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            icon: notification.icon,
            iconColor: notification.iconColor,
            backgroundColor: notification.backgroundColor,
            isRead: true,
            relatedId: notification.relatedId,
            createdAt: notification.createdAt,
          );
        }
        return notification;
      }).toList();

      final unread = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unread,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ApiService.put(
        endpoint: '/notifications/mark-all-read',
        body: {},
        auth: true,
      );

      final updatedNotifications = state.notifications.map((notification) {
        return DoctorNotificationModel(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          type: notification.type,
          icon: notification.icon,
          iconColor: notification.iconColor,
          backgroundColor: notification.backgroundColor,
          isRead: true,
          relatedId: notification.relatedId,
          createdAt: notification.createdAt,
        );
      }).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await ApiService.delete(
        endpoint: '/notifications/$notificationId',
        auth: true,
      );

      final updatedNotifications =
          state.notifications.where((n) => n.id != notificationId).toList();
      final unread = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unread,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final doctorNotificationProvider =
    StateNotifierProvider<DoctorNotificationNotifier, DoctorNotificationState>(
        (ref) {
  return DoctorNotificationNotifier();
});
