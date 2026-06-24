// Notification Model - Doctor notification ka data model
class DoctorNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String icon;
  final String iconColor;
  final String backgroundColor;
  final bool isRead;
  final String? relatedId;
  final String createdAt;

  const DoctorNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.isRead,
    this.relatedId,
    required this.createdAt,
  });

  // JSON se model create karne ke liye
  factory DoctorNotificationModel.fromJson(Map<String, dynamic> json) {
    return DoctorNotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      icon: json['icon'] ?? '',
      iconColor: json['iconColor'] ?? '',
      backgroundColor: json['backgroundColor'] ?? '',
      isRead: json['isRead'] ?? false,
      relatedId: json['relatedId'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  // Model ko JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'icon': icon,
      'iconColor': iconColor,
      'backgroundColor': backgroundColor,
      'isRead': isRead,
      'relatedId': relatedId,
      'createdAt': createdAt,
    };
  }
}
