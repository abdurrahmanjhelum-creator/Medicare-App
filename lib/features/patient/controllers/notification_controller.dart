import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_service.dart';
import '../models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    required this.notifications,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
    : super(
        NotificationState(
          notifications: [],
        ),
      ) {
    fetchNotifications();
  }

  // Fetch notifications from backend
  Future<void> fetchNotifications() async {
    // Security check: Only fetch if the user is a patient
    final role = await TokenService.getUserRole();
    if (role != 'patient') return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/notifications',
        auth: true,
      );

      final list = ApiService.unwrapList(response, listKey: 'notifications');
      final notificationsList =
          list.map((n) => NotificationModel.fromJson(n)).toList();
      state = state.copyWith(
        notifications: notificationsList,
        isLoading: false,
      );
    } catch (e) {
      if (e.toString().contains('permissions')) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.put(
        endpoint: '/notifications/mark-read',
        body: {'notificationId': notificationId},
        auth: true,
      );
      
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await ApiService.put(
        endpoint: '/notifications/mark-all-read',
        body: {},
        auth: true,
      );
      
      final updatedNotifications = state.notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await ApiService.delete(
        endpoint: '/notifications/$notificationId',
        auth: true,
      );
      
      final updatedNotifications =
          state.notifications.where((n) => n.id != notificationId).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
