import 'package:flutter/material.dart';
import '../widgets/inventory_glance.dart';
import '../widgets/notification_panel.dart';
import '../widgets/shopping_list_preview.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kitchen'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationPanel(),
            const SizedBox(height: 32),
            InventoryGlance(),
            const SizedBox(height: 32),
            ShoppingListPreview(),
          ],
        ),
      ),
// Find the FloatingActionButton in your build method and update its onPressed property

// ... inside the HomeScreen build method ...
floatingActionButton: FloatingActionButton(
  onPressed: () {
    // Navigate to the AddItemScreen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddItemScreen()),
    );
  },
  backgroundColor: Colors.teal,
  child: const Icon(Icons.add),
),
    );
  }
}