import 'package:flutter/material.dart';

// Emergency contact ka data model — pehle emergency_screen.dart ke andar tha
class EmergencyContactModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const EmergencyContactModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  static Color _parseColor(dynamic colorValue, Color fallback) {
    if (colorValue == null) return fallback;
    try {
      String colorStr = colorValue.toString().trim().replaceAll('#', '');
      if (colorStr.toLowerCase().startsWith('0x')) {
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

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    // Map icon string to IconData
    IconData getIcon(String iconName) {
      switch (iconName.toLowerCase()) {
        case 'phone':
        case 'phone_callback':
        case 'phone_callback_rounded':
          return Icons.phone_callback_rounded;
        case 'error':
        case 'error_outline':
        case 'error_outline_rounded':
          return Icons.error_outline_rounded;
        case 'local_hospital':
        case 'local_hospital_outlined':
          return Icons.local_hospital_outlined;
        default:
          return Icons.phone;
      }
    }

    return EmergencyContactModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      icon: getIcon(json['icon'] ?? 'phone'),
      iconColor: _parseColor(json['iconColor'], const Color(0xFF0FA485)),
      iconBackgroundColor: _parseColor(json['iconBackgroundColor'], const Color(0xFFE0F2F1)),
    );
  }
}
