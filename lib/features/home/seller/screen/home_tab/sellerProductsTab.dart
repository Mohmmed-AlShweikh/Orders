import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/home/buyer/provider/product_provider.dart';
import 'package:orders/product_card.dart';

class SellerProductsTab extends ConsumerWidget {
  const SellerProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text("No user"),
          );
        }

        final productsAsync =
            ref.watch(sellerProductsProvider(user.uid));

        return productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return const Center(
                child: Text(
                  "No products yet",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ProductCard(product: product);
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
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}