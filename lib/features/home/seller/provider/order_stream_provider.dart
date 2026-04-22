import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders/features/home/seller/data/order_model.dart';
import 'package:orders/features/home/seller/provider/order_repository.dart';

final sellerOrdersProvider =
    StreamProvider.family<List<Orders>, String>((ref, sellerId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('sellerId', isEqualTo: sellerId)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Orders.fromMap(doc.data()))
        .toList();
  });
});

final orderByIdProvider = StreamProvider.family((ref, String orderId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .snapshots()
      .map((doc) => Orders.fromMap(doc.data()!));
});


final orderRepoProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});