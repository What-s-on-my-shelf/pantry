import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import '../widgets/shopping_checklist.dart'; // We will create this next

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController based on the number of shopping lists
    final manager = Provider.of<InventoryManager>(context, listen: false);
    _tabController = TabController(length: manager.shoppingLists.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<InventoryManager>(context);
    final shoppingLists = manager.shoppingLists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        backgroundColor: Colors.grey[900],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: shoppingLists.map((list) => Tab(text: list.storeName)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: shoppingLists.map((list) => ShoppingChecklist(shoppingList: list)).toList(),
      ),
    );
  }
}