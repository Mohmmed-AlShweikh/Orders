import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/home/buyer/data/product_model.dart';
import 'package:orders/features/home/buyer/provider/product_controller.dart';


class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final price = TextEditingController();
  final imageUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authUserProvider);
    final state = ref.watch(productControllerProvider);

    return Container(
  

      child: auth.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
              
                  _field(title, "Title"),
                  _field(desc, "Description"),
                  _field(price, "Price"),
                  _field(imageUrl, "Image URL"),
              
                  const SizedBox(height: 20),
              
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            final product = Product(
                              id: "",
                              title: title.text,
                              description: desc.text,
                              price: double.parse(price.text),
                              imageUrl: imageUrl.text,
                              sellerId: user.uid,
                            );
              
                            await ref
                                .read(productControllerProvider.notifier)
                                .addProduct(product);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                          },
                    child: state.isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Add Product"),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
        ),
      ),
    );
  }
}