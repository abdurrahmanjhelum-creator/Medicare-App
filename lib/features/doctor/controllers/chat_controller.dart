import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_service.dart';

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

class DoctorChatState {
  final bool isLoading;
  final bool isSending;
  final String? error;
  final List<ChatMessageModel> messages;
  final String? currentUserId;

  const DoctorChatState({
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.messages = const [],
    this.currentUserId,
  });

  DoctorChatState copyWith({
    bool? isLoading,
    bool? isSending,
    String? error,
    List<ChatMessageModel>? messages,
    String? currentUserId,
  }) {
    return DoctorChatState(
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      messages: messages ?? this.messages,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

class DoctorChatNotifier extends StateNotifier<DoctorChatState> {
  DoctorChatNotifier() : super(const DoctorChatState());

  Future<void> loadMessages(String patientUserId, String currentUserId) async {
    state = state.copyWith(isLoading: true, error: null, currentUserId: currentUserId);

    try {
      final response = await ApiService.get(
        endpoint: '/chat/messages',
        auth: true,
        queryParams: {'userId': patientUserId},
      );

      final list = ApiService.unwrapList(response, listKey: 'messages');
      final messages = list
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>, currentUserId))
          .toList();

      state = state.copyWith(isLoading: false, messages: messages);

      await ApiService.put(
        endpoint: '/chat/messages/$patientUserId/read',
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

  Future<void> sendMessage(String patientUserId, String content) async {
    if (content.trim().isEmpty || state.currentUserId == null) return;

    state = state.copyWith(isSending: true, error: null);

    try {
      final response = await ApiService.post(
        endpoint: '/chat/send',
        body: {
          'receiverId': patientUserId,
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

final doctorChatProvider =
    StateNotifierProvider.autoDispose<DoctorChatNotifier, DoctorChatState>((ref) {
  return DoctorChatNotifier();
});
