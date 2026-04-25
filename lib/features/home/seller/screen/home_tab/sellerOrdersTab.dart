import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/home/seller/provider/order_stream_provider.dart';

class SellerOrdersTab extends ConsumerWidget {
  const SellerOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text("No user"));
        }

        final ordersAsync = ref.watch(sellerOrdersProvider(user.uid));

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
            final filteredOrders =
                  orders.where((o) => o.status != "accepted").toList();

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];

                return Card(
                  color: const Color(0xff1e293b),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      "Order: ${order.productId}",
                      style: const TextStyle(color: Colors.white),
                    ),

                    subtitle: Text(
                      "Price: ${order.price} \$\nStatus: ${order.status}",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),

                      onSelected: (value) async {
                        await _updateStatus(ref, order.id, value, order.buyerId, order.sellerId);
                      },

                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "accepted",
                          child: Text("Accept"),
                        ),
                        PopupMenuItem(
                          value: "rejected",
                          child: Text("Reject"),
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
            child: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },

      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) => Center(child: Text(e.toString())),
    );
  }

  Future<void> _updateStatus(
  WidgetRef ref,
  String orderId,
  String status,
  String buyerId,
  String sellerId,
) async {
  await ref
      .read(orderRepoProvider)
      .updateStatus(orderId, status, buyerId, sellerId);
}
}