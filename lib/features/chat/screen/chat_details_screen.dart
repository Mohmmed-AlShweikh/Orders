import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/chat/provider/chat_provider.dart';
import 'package:orders/features/chat/data/message_model.dart';
import 'package:orders/features/chat/provider/chat_controller.dart';
import 'package:orders/features/chat/provider/chat_repository.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String otherUserId;

  const ChatDetailScreen({
    super.key,
    required this.orderId,
    required this.otherUserId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? otherUserName;

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final name = await ChatRepository().getUserName(widget.otherUserId);
    setState(() {
      otherUserName = name;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.orderId));
    final userAsync = ref.watch(authUserProvider);

    final user = userAsync.value;

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),

      appBar: AppBar(
        iconTheme: const IconThemeData(
    color: Colors.white, // لون زر الرجوع
  ),
        backgroundColor: const Color(0xff0f172a),
        title: Text(otherUserName ?? "Loading...",style: const TextStyle(color: Colors.white),),
      ),

      body: Column(
        children: [
          /// 💬 MESSAGES
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                _scrollToBottom();

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == user?.uid;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          /// 💬 BUBBLE
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xff22c55e)
                                  : const Color(0xff334155),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(isMe ? 14 : 4),
                                bottomRight: Radius.circular(isMe ? 4 : 14),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              msg.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          /// 🕒 TIME
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              left: 4,
                              right: 4,
                            ),
                            child: Text(
                              _formatTime(msg.createdAt),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          /// ✍️ INPUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xff1e293b),
              border: Border(
                top: BorderSide(color: Colors.white10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    final text = controller.text.trim();
                    if (text.isEmpty || user == null) return;

                    controller.clear();

                    final msg = ChatMessage(
                      id: DateTime.now().toString(),
                      senderId: user.uid,
                      text: text,
                      createdAt: DateTime.now(),
                    );

                    await ref
                        .read(chatControllerProvider.notifier)
                        .sendMessage(widget.orderId, msg);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}