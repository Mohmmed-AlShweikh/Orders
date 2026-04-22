import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders/features/chat/data/message_model.dart';

class ChatRepository {
  final _db = FirebaseFirestore.instance;

  /// 📥 stream messages
  Stream<List<ChatMessage>> getMessages(String orderId) {
    return _db
        .collection('chats')
        .doc(orderId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();
    });
  }

  /// 📤 send message
  Future<void> sendMessage({
    required String orderId,
    required ChatMessage message,
  }) async {
    await _db
        .collection('chats')
        .doc(orderId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<void> createChat({
  required String orderId,
  required String buyerId,
  required String sellerId,
   required String buyerName,
  required String sellerName,
}) async {
  await _db.collection('chats').doc(orderId).set({
    'orderId': orderId,
    'buyerId': buyerId,
    'sellerId': sellerId,
     'buyerName': buyerName,
    'sellerName': sellerName,
     'lastMessage': '',
    'participants': [buyerId, sellerId],
    'createdAt': DateTime.now().toIso8601String(),
  });
}

  Future<String?> getChatIdByOrder(String orderId) async {
    final doc = await _db.collection('chats').doc(orderId).get();
    if (doc.exists) {
      return doc.id;
    }
    return null;
  }

  Future<String> getUserName(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data()?['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  Future<String?> getLastMessage(String orderId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('chats')
      .doc(orderId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;

  return snapshot.docs.first['text'];
}
Stream<DocumentSnapshot<Map<String, dynamic>>> getChatStream(String orderId) {
  return _db.collection('chats').doc(orderId).snapshots();
}
}
