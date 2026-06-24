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
      iconColor: Color(int.parse(json['iconColor']?.toString().replaceAll('0xFF', '0xff') ?? '0xff0FA485')),
      iconBackgroundColor: Color(int.parse(json['iconBackgroundColor']?.toString().replaceAll('0xFF', '0xff') ?? '0xffE0F2F1')),
    );
  }
}
