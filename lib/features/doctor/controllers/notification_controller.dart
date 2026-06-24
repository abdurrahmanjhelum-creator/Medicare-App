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

  // Notifications load karein
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // API se data fetch karein
      final response = await ApiService.get(
        endpoint: '/notifications',
        auth: true,
      );
      
      // API response se notifications list create karein
      final notificationsList = (response['data'] as List)
          .map((e) => DoctorNotificationModel.fromJson(e))
          .toList();
      
      // Unread count calculate karein
      final unread = notificationsList.where((n) => !n.isRead).length;
      
      state = state.copyWith(
        isLoading: false,
        notifications: notificationsList,
        unreadCount: unread,
      );
    } catch (e) {
      // Agar API fail ho jaye toh dummy data use karein
      await Future.delayed(const Duration(seconds: 1));
      
      final dummyNotifications = [
        DoctorNotificationModel(
          id: 'n1',
          title: 'New Appointment',
          message: 'Ahmed Khan booked an appointment for tomorrow at 10:00 AM',
          type: 'appointment',
          icon: 'calendar',
          iconColor: '#4CAF50',
          backgroundColor: '#E8F5E9',
          isRead: false,
          relatedId: 'apt1',
          createdAt: '2024-06-22 09:30 AM',
        ),
        DoctorNotificationModel(
          id: 'n2',
          title: 'New Review',
          message: 'Fatima Ali gave you a 5-star rating',
          type: 'review',
          icon: 'star',
          iconColor: '#FFC107',
          backgroundColor: '#FFF8E1',
          isRead: false,
          relatedId: 'r1',
          createdAt: '2024-06-22 08:15 AM',
        ),
        DoctorNotificationModel(
          id: 'n3',
          title: 'Payment Received',
          message: 'Payment of Rs. 1500 received from Usman Ahmed',
          type: 'payment',
          icon: 'payment',
          iconColor: '#2196F3',
          backgroundColor: '#E3F2FD',
          isRead: true,
          relatedId: 'pay1',
          createdAt: '2024-06-21 04:30 PM',
        ),
      ];
      
      final unread = dummyNotifications.where((n) => !n.isRead).length;
      
      state = state.copyWith(
        isLoading: false,
        notifications: dummyNotifications,
        unreadCount: unread,
      );
    }
  }

  // Notification read mark karein
  Future<void> markAsRead(String notificationId) async {
    try {
      // API call karein
      await ApiService.patch(
        endpoint: '/notifications/$notificationId/read',
        body: {},
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

  // Sab notifications read mark karein
  Future<void> markAllAsRead() async {
    try {
      // API call karein
      await ApiService.patch(
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

  // Notification delete karein
  Future<void> deleteNotification(String notificationId) async {
    try {
      // API call karein
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

// Notification Provider
final doctorNotificationProvider =
    StateNotifierProvider<DoctorNotificationNotifier, DoctorNotificationState>(
        (ref) {
  return DoctorNotificationNotifier();
});
