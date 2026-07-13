import 'package:flutter/material.dart';

// Notification ka data model — notification_screen se alag folder mein
class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isRead;

  NotificationModel({
    required this.id,
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
      id: id,
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
        case 'event_available':
          return Icons.event_available;
        case 'payment':
          return Icons.payment;
        case 'warning_amber_rounded':
          return Icons.warning_amber_rounded;
        case 'chat_bubble_outline':
          return Icons.chat_bubble_outline;
        default:
          return Icons.notifications_outlined;
      }
    }

    // Map type to icon
    IconData getIconByType(String type) {
      switch (type.toLowerCase()) {
        case 'appointment':
          return Icons.event_available;
        case 'payment':
          return Icons.payment;
        case 'alert':
          return Icons.warning_amber_rounded;
        case 'message':
          return Icons.chat_bubble_outline;
        default:
          return Icons.notifications_outlined;
      }
    }

    // Map type to color
    Color getColorByType(String type) {
      switch (type.toLowerCase()) {
        case 'appointment':
          return const Color(0xff089B73);
        case 'payment':
          return Colors.blue;
        case 'alert':
          return Colors.orange;
        case 'message':
          return Colors.purple;
        default:
          return const Color(0xff089B73);
      }
    }

    Color parseColor(dynamic colorValue, Color fallback) {
      if (colorValue == null) return fallback;
      String colorStr = colorValue.toString().trim();
      try {
        if (colorStr.startsWith('#')) {
          colorStr = colorStr.replaceFirst('#', '');
        } else if (colorStr.toLowerCase().startsWith('0x')) {
          colorStr = colorStr.substring(2);
        }
        
        if (colorStr.length == 6) {
          colorStr = 'FF$colorStr';
        }
        
        return Color(int.parse(colorStr, radix: 16));
      } catch (e) {
        return fallback;
      }
    }

    final type = json['type'] ?? 'info';
    
    return NotificationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] ?? 'Notification',
      subtitle: json['message'] ?? json['subtitle'] ?? '',
      time: json['time'] ?? _formatTime(json['createdAt']),
      icon: json['icon'] != null ? getIcon(json['icon']) : getIconByType(type),
      iconColor: parseColor(json['iconColor'], getColorByType(type)),
      iconBgColor: parseColor(json['iconBgColor'], getColorByType(type).withAlpha(25)),
      isRead: json['isRead'] ?? false,
    );
  }

  static String _formatTime(dynamic createdAt) {
    if (createdAt == null) return 'Just now';
    try {
      final dateTime = DateTime.parse(createdAt.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (_) {
      return 'Just now';
    }
  }
}
