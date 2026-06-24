import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiService.get(
        endpoint: '/notifications',
        auth: true,
      );

      final data = response['data'] ?? response;
      if (data is List) {
        final notifications = data.map((n) => NotificationModel.fromJson(n)).toList();
        state = state.copyWith(
          notifications: notifications,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // Load dummy data on error
      _loadDummyData();
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.patch(
        endpoint: '/notifications/mark-read',
        body: {'notificationId': notificationId},
        auth: true,
      );
      await fetchNotifications();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await ApiService.patch(
        endpoint: '/notifications/mark-all-read',
        body: {},
        auth: true,
      );
      await fetchNotifications();
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
      await fetchNotifications();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _loadDummyData() {
    state = state.copyWith(
      notifications: [
        NotificationModel(
          title: "Appointment Reminder",
          subtitle:
              "You have an appointment with Dr. Sarah Johnson tomorrow at 10:00 AM",
          time: "2 hours ago",
          icon: Icons.calendar_today_outlined,
          iconBgColor: const Color(0xFFE0F2F1),
          iconColor: AppColors.primaryGreen,
          isRead: false,
        ),
        NotificationModel(
          title: "Lab Report Ready",
          subtitle:
              "Your blood test results are now available for download",
          time: "5 hours ago",
          icon: Icons.description_outlined,
          iconBgColor: const Color(0xFFE0F2F1),
          iconColor: AppColors.primaryGreen,
          isRead: false,
        ),
        NotificationModel(
          title: "Prescription Refill",
          subtitle: "Your prescription for Amoxicillin is ready for pickup",
          time: "1 day ago",
          icon: Icons.medication_outlined,
          iconBgColor: const Color(0xFFFFF8E1),
          iconColor: AppColors.warning,
          isRead: true,
        ),
      ],
    );
  }
}
