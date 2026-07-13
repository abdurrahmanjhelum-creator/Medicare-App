import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';

class ChatMessageModel {
  final String id;
  final String content;
  final bool isSentByMe;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.isSentByMe,
    required this.createdAt,
  });

  String get formattedTime => DateFormat('h:mm a').format(createdAt);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final senderId = (json['senderId'] ?? '').toString();
    final createdAtRaw = json['createdAt'];
    DateTime createdAt;
    if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return ChatMessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isSentByMe: senderId == currentUserId,
      createdAt: createdAt,
    );
  }
}

class PatientChatState {
  final bool isLoading;
  final bool isSending;
  final String? error;
  final List<ChatMessageModel> messages;
  final String? currentUserId;

  const PatientChatState({
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.messages = const [],
    this.currentUserId,
  });

  PatientChatState copyWith({
    bool? isLoading,
    bool? isSending,
    String? error,
    List<ChatMessageModel>? messages,
    String? currentUserId,
  }) {
    return PatientChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      messages: messages ?? this.messages,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

class PatientChatNotifier extends StateNotifier<PatientChatState> {
  PatientChatNotifier() : super(const PatientChatState());

  Future<void> loadMessages(String doctorUserId, String currentUserId) async {
    state = state.copyWith(isLoading: true, error: null, currentUserId: currentUserId);

    try {
      final response = await ApiService.get(
        endpoint: '/chat/messages',
        auth: true,
        queryParams: {'userId': doctorUserId},
      );

      final list = ApiService.unwrapList(response, listKey: 'messages');
      final messages = list
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId))
          .toList();

      state = state.copyWith(isLoading: false, messages: messages);

      // Mark as read
      await ApiService.put(
        endpoint: '/chat/messages/$doctorUserId/read',
        body: {},
        auth: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> sendMessage(String doctorUserId, String content) async {
    if (content.trim().isEmpty || state.currentUserId == null) return;

    state = state.copyWith(isSending: true, error: null);

    try {
      final response = await ApiService.post(
        endpoint: '/chat/send',
        body: {
          'receiverId': doctorUserId,
          'content': content.trim(),
        },
        auth: true,
      );

      final data = ApiService.unwrapMap(response);
      final messageJson = data.containsKey('content')
          ? data
          : (data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data);

      final newMessage = ChatMessageModel.fromJson(messageJson, state.currentUserId!);

      state = state.copyWith(
        isSending: false,
        messages: [...state.messages, newMessage],
      );
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final patientChatProvider =
    StateNotifierProvider.autoDispose<PatientChatNotifier, PatientChatState>((ref) {
  return PatientChatNotifier();
});
