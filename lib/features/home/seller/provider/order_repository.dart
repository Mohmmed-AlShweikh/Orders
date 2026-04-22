import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders/features/chat/provider/chat_repository.dart';
import 'package:orders/features/home/seller/data/order_model.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createOrder(Orders order) async {
    await _db.collection('orders').doc(order.id).set(order.toMap());
  }

  Stream<List<Orders>> sellerOrders(String sellerId) {
    return _db
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Orders.fromMap(e.data())).toList());
  }


   Future<void> cancelOrder(String orderId) async {
    await _db
        .collection('orders')
        .doc(orderId)
        .update({'status': 'cancelled'});
  }

   Future<void> updateStatus(
    String orderId,
    String status,
    String buyerId,
    String sellerId,
  ) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
    });

    /// 🔥 مهم: لو تم قبول الطلب نعمل Chat
    if (status == "accepted") {

      final chatRepo = ChatRepository();
       final buyerName = await chatRepo.getUserName(buyerId);
  final sellerName = await chatRepo.getUserName(sellerId);

       await chatRepo.createChat(
      orderId: orderId,
      buyerId: buyerId,
      sellerId: sellerId,
       buyerName: buyerName,
    sellerName: sellerName,
      
    );
    }
  }


 

}