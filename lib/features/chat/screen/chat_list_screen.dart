import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/features/auth/data/user_role.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/chat/provider/chat_provider.dart';
import 'package:orders/features/home/buyer/provider/order_provider.dart';
import 'package:orders/features/home/seller/provider/order_stream_provider.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        title: const Text("Chats",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff0f172a),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const SizedBox();

          final ordersStream = user.role == UserRole.buyer
              ? ref.watch(buyerOrdersProvider(user.uid))
              : ref.watch(sellerOrdersProvider(user.uid));

          return ordersStream.when(
            data: (orders) {

              final filteredOrders =
                  orders.where((o) => o.status == "accepted").toList();

              if (filteredOrders.isEmpty) {
                return const Center(
                  child: Text(
                    "No chats yet",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredOrders.length,
                itemBuilder: (context, i) {
                  final order = filteredOrders[i];
                  final lastMessageAsync = ref.watch(lastMessagesProvider(order.id));


                  final otherUserId = order.buyerId == user.uid
                      ? order.sellerId
                      : order.buyerId;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff1e293b),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        "🛒 ${order.productTitle}", // 👈 هون التعديل
                        style: const TextStyle(color: Colors.white),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status: ${order.status}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                           lastMessageAsync.when(
  data: (msg) => Text( "Last message: $msg"),
  loading: () => const Text("..."),
  error: (_, __) => const Text("Error"),
),
                        ],
                      ),

                      trailing: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),

                      onTap: () {
                        context.push(
                          '/chat-detail/${order.id}/$otherUserId',
                        
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
      ),
    );
  }
}