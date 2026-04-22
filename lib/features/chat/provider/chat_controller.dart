import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/chat/provider/chat_provider.dart';
import 'package:orders/features/chat/provider/chat_repository.dart';
import '../data/message_model.dart';

class ChatController extends StateNotifier<AsyncValue<void>> {
  final ChatRepository repo;

  ChatController(this.repo) : super(const AsyncData(null));

  Future<void> sendMessage(String orderId, ChatMessage message) async {
    state = const AsyncLoading();

    try {
      await repo.sendMessage(orderId: orderId, message: message);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, AsyncValue<void>>((ref) {
  return ChatController(ref.watch(chatRepoProvider));
});