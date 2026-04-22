import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/chat/provider/chat_repository.dart';
import '../data/message_model.dart';

final chatRepoProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final messagesProvider =
    StreamProvider.family<List<ChatMessage>, String>((ref, orderId) {
  final repo = ref.watch(chatRepoProvider);
  return repo.getMessages(orderId);
});



final lastMessagesProvider =
    FutureProvider.family<String?, String>((ref, orderId) {
  final repo = ref.watch(chatRepoProvider);
  return repo.getLastMessage(orderId);
});










