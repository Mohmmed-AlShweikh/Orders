import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/home/buyer/screen/add_product_screen.dart';
import 'package:orders/features/home/seller/screen/home_tab/sellerOrdersTab.dart';
import 'package:orders/features/home/seller/screen/home_tab/sellerProductsTab.dart';

class SellerHomeScreen extends ConsumerStatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  ConsumerState<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends ConsumerState<SellerHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void openAddProductSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff0f172a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return const AddProductScreen();
      },
    );
  }
@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text(
           "Seller Dashboard",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0f172a),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2), text: "Products"),
            Tab(icon: Icon(Icons.shopping_bag), text: "Orders"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [
          SellerProductsTab(),
          SellerOrdersTab(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddProductSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}