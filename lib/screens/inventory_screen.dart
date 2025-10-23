import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // <-- 1. ADD THIS IMPORT
import '../services/inventory_manager.dart';
import '../widgets/inventory_list_item.dart';
import 'add_item_screen.dart'; // <-- 2. ADD THIS IMPORT

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          return InventoryListItem(item: inventory[index]);
        },
      ),
      // --- 3. ADD THIS ENTIRE SECTION ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddItemScreen()),
          );
        },
        backgroundColor: Colors.teal,
        child: const FaIcon(FontAwesomeIcons.plus, size: 30), // Using the new icon
      ),
      // --- END OF NEW SECTION ---
    );
  }
}