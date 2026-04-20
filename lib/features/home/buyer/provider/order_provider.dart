import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/home/seller/data/order_model.dart';

final buyerOrdersProvider =
    StreamProvider.family((ref, buyerId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('buyerId', isEqualTo: buyerId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Orders.fromMap(doc.data()))
            .toList();
      });
});