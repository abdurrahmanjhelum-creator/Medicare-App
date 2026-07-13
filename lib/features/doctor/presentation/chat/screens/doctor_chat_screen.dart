// Doctor Chat Screen - Real-time chat with patients via backend API
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/services/token_service.dart';
import '../../../controllers/chat_controller.dart';

class DoctorChatScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const DoctorChatScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends ConsumerState<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initChat);
  }

  Future<void> _initChat() async {
    _currentUserId = await TokenService.getUserId();
    if (_currentUserId != null && mounted) {
      await ref.read(doctorChatProvider.notifier).loadMessages(widget.patientId, _currentUserId!);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await ref.read(doctorChatProvider.notifier).sendMessage(widget.patientId, text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(doctorChatProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          widget.patientName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatState.error != null && chatState.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chatState.error!,
                              style: const TextStyle(color: AppColors.errorRed),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _initChat,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : chatState.messages.isEmpty
                        ? const Center(
                            child: Text(
                              'No messages yet. Start the conversation.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(AppDimensions.spacing16),
                            itemCount: chatState.messages.length,
                            itemBuilder: (context, index) {
                              final message = chatState.messages[index];
                              return _MessageBubble(
                                message: message.content,
                                isSentByMe: message.isSentByMe,
                                time: message.formattedTime,
                              );
                            },
                          ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.scaffoldBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing16,
                        vertical: AppDimensions.spacing12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: chatState.isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: AppColors.white),
                    onPressed: chatState.isSending ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final String time;

  const _MessageBubble({
    required this.message,
    required this.isSentByMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing16),
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: isSentByMe ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? AppColors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              time,
              style: TextStyle(
                color: isSentByMe
                    ? AppColors.white.withAlpha((0.7 * 255).round())
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
