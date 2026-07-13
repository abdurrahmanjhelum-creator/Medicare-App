import 'package:intl/intl.dart';

class ConversationModel {
  final String otherUserId;
  final String otherUserName;
  final String otherUserImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ConversationModel({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  String get formattedTime {
    final now = DateTime.now();
    if (now.day == lastMessageTime.day &&
        now.month == lastMessageTime.month &&
        now.year == lastMessageTime.year) {
      return DateFormat('h:mm a').format(lastMessageTime);
    }
    return DateFormat('dd/MM/yy').format(lastMessageTime);
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    // The structure might vary based on backend implementation
    // Assuming: { otherUser: { id, name, image }, lastMessage: { content, createdAt }, unreadCount }
    final otherUser = json['otherUser'] as Map<String, dynamic>? ?? {};
    final lastMsg = json['lastMessage'] as Map<String, dynamic>? ?? {};
    
    return ConversationModel(
      otherUserId: otherUser['_id']?.toString() ?? otherUser['id']?.toString() ?? '',
      otherUserName: otherUser['name']?.toString() ?? 'Doctor',
      otherUserImage: otherUser['profileImage']?.toString() ?? '',
      lastMessage: lastMsg['content']?.toString() ?? '',
      lastMessageTime: lastMsg['createdAt'] != null 
          ? DateTime.tryParse(lastMsg['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
