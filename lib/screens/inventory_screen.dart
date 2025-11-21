import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import '../widgets/inventory_list_item.dart';
import 'add_item_screen.dart';
import 'barcode_scanner_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  // This method shows the modal bottom sheet for adding items
  // It is INSIDE the class, but OUTSIDE the build method
  void _showAddItemOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[850],
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.barcode, color: Colors.white),
              title: const Text('Scan Barcode', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.of(ctx).pop(); // Close the bottom sheet
                
                // Request camera permission
                var status = await Permission.camera.request();
                
                // --- FIX for 'use_build_context_synchronously' ---
                // We check if the widget is still mounted *after* the 'await'
                if (!context.mounted) return; 
                
                if (status.isGranted) {
                  // Navigate to the scanner
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const BarcodeScannerScreen()),
                  );
                } else {
                  // Handle permission denied
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Camera permission is required to scan barcodes.')));
                }
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white),
              title: const Text('Enter Manually', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(ctx).pop(); // Close the bottom sheet
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddItemScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to listen for changes to the inventory
    return Consumer<InventoryManager>(
      builder: (context, inventoryManager, child) {
        final inventory = inventoryManager.inventory;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Full Inventory'),
            backgroundColor: Colors.grey[900],
          ),
          body: ListView.builder(
            itemCount: inventory.length,
            itemBuilder: (ctx, index) {
              final item = inventory[index];
              // Wrap the list item in a Dismissible for swipe-to-delete
              return Dismissible(
                key: ValueKey(item.id), // Unique key is essential
                direction: DismissDirection.endToStart, // Swipe from right to left
                onDismissed: (direction) {
                  // Call the manager to delete the item
                  inventoryManager.updateItemQuantity(item.id, 0);
                  // Show a snackbar to confirm deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} deleted'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                // This is the red background shown when swiping
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
                ),
                // This is the actual item widget
                child: InventoryListItem(item: item),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showAddItemOptions(context); // Call the method to show options
            },
            backgroundColor: Colors.teal,
            child: const FaIcon(FontAwesomeIcons.plus, size: 30),
          ),
        );
      },
    );
  }
}