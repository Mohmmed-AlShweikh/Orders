import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orders/features/home/buyer/screen/home_tab/buyerOrdersTab.dart';
import 'package:orders/features/home/buyer/screen/home_tab/buyerProductsTab.dart';



class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() =>
      _BuyerHomeScreenState();
}

class _BuyerHomeScreenState
    extends ConsumerState<BuyerHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        title: Text(
           "Buyer Dashboard",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0f172a),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag), text: "Products"),
            Tab(icon: Icon(Icons.receipt_long), text: "My Orders"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [
          BuyerProductsTab(),
          BuyerOrdersTab(),
        ],
      ),
    );
  }
}