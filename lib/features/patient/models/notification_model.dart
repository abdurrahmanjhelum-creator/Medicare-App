import 'package:flutter/material.dart';

// Notification ka data model — notification_screen se alag folder mein
class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      title: title,
      subtitle: subtitle,
      time: time,
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Map icon string to IconData
    IconData getIcon(String iconName) {
      switch (iconName.toLowerCase()) {
        case 'calendar_today':
        case 'calendar_today_outlined':
          return Icons.calendar_today_outlined;
        case 'description':
        case 'description_outlined':
          return Icons.description_outlined;
        case 'medication':
        case 'medication_outlined':
          return Icons.medication_outlined;
        case 'notifications':
        case 'notifications_outlined':
          return Icons.notifications_outlined;
        default:
          return Icons.notifications_outlined;
      }
    }

    return NotificationModel(
      title: json['title'] ?? '',
      subtitle: json['message'] ?? json['subtitle'] ?? '',
      time: json['time'] ?? '',
      icon: getIcon(json['icon'] ?? 'notifications'),
      iconColor: Color(int.parse(json['iconColor']?.toString().replaceAll('0xFF', '0xff') ?? '0xff089B73')),
      iconBgColor: Color(int.parse(json['iconBgColor']?.toString().replaceAll('0xFF', '0xff') ?? '0xffE0F2F1')),
      isRead: json['isRead'] ?? false,
    );
  }
}
