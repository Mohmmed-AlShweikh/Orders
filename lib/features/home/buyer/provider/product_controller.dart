import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/home/buyer/data/product_model.dart';
import 'package:orders/features/home/buyer/provider/product_provider.dart';


class ProductController extends StateNotifier<AsyncValue<void>> {
  final ProductRepository repo;

  ProductController(this.repo) : super(const AsyncData(null));

  Future<void> addProduct(Product product) async {
    state = const AsyncLoading();

    try {
      await repo.addProduct(product);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final productControllerProvider =
    StateNotifierProvider<ProductController, AsyncValue<void>>((ref) {
  final repo = ref.watch(productRepoProvider);
  return ProductController(repo);
});