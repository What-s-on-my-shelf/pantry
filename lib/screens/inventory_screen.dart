import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import '../widgets/inventory_list_item.dart'; // <-- 1. IMPORT the new widget

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We now need to listen for changes to rebuild the list
    final inventoryManager = Provider.of<InventoryManager>(context);
    final inventory = inventoryManager.inventory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Inventory'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView.builder(
        itemCount: inventory.length,
        itemBuilder: (ctx, index) {
          // 2. USE the new widget here, passing the item data
          return InventoryListItem(item: inventory[index]);
        },
      ),
    );
  }
}