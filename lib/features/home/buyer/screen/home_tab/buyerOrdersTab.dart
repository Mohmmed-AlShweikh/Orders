import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/chat/provider/chat_repository.dart';
import 'package:orders/features/home/buyer/provider/order_provider.dart';
import 'package:orders/features/home/seller/provider/order_controller.dart';

class BuyerOrdersTab extends ConsumerWidget {
  const BuyerOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);
    final orderState = ref.watch(orderControllerProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text("No user"));

        final ordersAsync =
            ref.watch(buyerOrdersProvider(user.uid));

        return ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  "No orders yet",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final order = orders[i];

                return Card(
                  color: const Color(0xff1e293b),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        /// 📦 Product
                        Text(
                          "Product: ${order.productId}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// 💰 Price
                        Text(
                          "Price: ${order.price} \$",
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// 📊 Status + Actions
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            /// Status
                            Text(
                              order.status,
                              style: TextStyle(
                                color: _getStatusColor(
                                    order.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// 🔥 Actions
                            _buildActions(
                              context,
                              ref,
                              order,
                              orderState,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(e.toString()),
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          Center(child: Text(e.toString())),
    );
  }

  /// 🎯 ACTIONS
  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    dynamic order,
    AsyncValue state,
  ) {
    /// 🟡 Cancel
    if (order.status == "pending") {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        onPressed: state.isLoading
            ? null
            : () async {
                await ref
                    .read(orderControllerProvider.notifier)
                    .cancelOrder(order.id);
              },
        child: state.isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text("Cancel"),
      );
    }

  

    /// ❌ Nothing
    return const SizedBox();
  }

  /// 🎨 Status Colors
  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "accepted":
        return Colors.blue;
      case "completed":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.white;
    }
  }
}