import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders/features/home/buyer/data/product_model.dart';




class ProductRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Stream<List<Product>> getSellerProducts(String sellerId) {
  return _firestore
      .collection('products')
      .where('sellerId', isEqualTo: sellerId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data()))
            .toList();
      });
}
}



final sellerProductsProvider =
    StreamProvider.family<List<Product>, String>((ref, sellerId) {
  final repo = ref.watch(productRepoProvider);
  return repo.getSellerProducts(sellerId);
});


final productRepoProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productStreamProvider = StreamProvider<List<Product>>((ref) {
  final repo = ref.watch(productRepoProvider);
  return repo.getProducts();
});