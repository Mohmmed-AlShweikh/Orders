import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';
import 'package:orders/features/auth/data/user_role.dart';
import 'package:orders/features/home/buyer/screen/buyer_home_screen.dart';
import 'package:orders/features/home/seller/screen/seller_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authUserProvider);
    final user = auth.value;

    if (user == null) {
      return const Center(child: Text("No user"));
    }

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
    

      body: user.role == UserRole.buyer
          ? const BuyerHomeScreen()
          : const SellerHomeScreen(),
    );
  }
}
