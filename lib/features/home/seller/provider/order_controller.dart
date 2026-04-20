import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/home/seller/provider/order_repository.dart';
import 'package:orders/features/home/seller/provider/order_stream_provider.dart';

final orderControllerProvider =
    StateNotifierProvider<OrderController, AsyncValue<void>>((ref) {
  final repo = ref.watch(orderRepoProvider);
  return OrderController(repo);
});

class OrderController extends StateNotifier<AsyncValue<void>> {
  final OrderRepository repo;

  OrderController(this.repo) : super(const AsyncData(null));

  Future<void> cancelOrder(String orderId) async {
    state = const AsyncLoading();
    try {
      await repo.cancelOrder(orderId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}