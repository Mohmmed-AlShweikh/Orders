import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/features/auth/data/user_role.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/home/buyer/provider/product_provider.dart';
import 'package:orders/features/home/seller/data/order_model.dart';
import 'package:orders/features/home/seller/provider/order_repository.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productStreamProvider);
    final userAsync = ref.watch(authUserProvider);

    return productsAsync.when(
      data: (products) {
        final product = products.firstWhere((p) => p.id == productId);

        return userAsync.when(
          data: (user) {
            if (user == null) {
              return const Scaffold(body: Center(child: Text("No user")));
            }

            final isBuyer = user.role == UserRole.buyer;

            return Scaffold(
              backgroundColor: const Color(0xff0f172a),

              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  product.title,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xff0f172a),
              ),

              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🖼 IMAGE
                    Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.white38,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 📦 INFO
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          Text(
                            product.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// PRICE
                          Text(
                            "${product.price} \$",
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// DESCRIPTION
                          const Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            product.description,
                            style: const TextStyle(
                              color: Colors.white60,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 💳 BUY BUTTON (BUYER ONLY)
                    if (isBuyer)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                            ),
                            onPressed: () async {
                              final order = Orders(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                productId: product.id,
                                buyerId: user.uid,
                                sellerId: product.sellerId,
                                price: product.price,
                                status: "pending",
                                createdAt: DateTime.now(),
                                productTitle: product.title,
                              );

                              await OrderRepository().createOrder(order);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Order placed successfully"),
                                ),
                              );
                              context.pop();
                            },
                            child: const Text(
                              "Buy Now",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },

          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

          error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
        );
      },

      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
    );
  }
}
