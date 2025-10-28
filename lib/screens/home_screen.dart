import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/inventory_manager.dart';
import '../services/settings_manager.dart';
import '../widgets/inventory_glance.dart';
import '../widgets/notification_panel.dart';
import '../widgets/shopping_list_preview.dart';
import 'add_item_screen.dart';
import 'barcode_scanner_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This method shows the modal bottom sheet for adding items
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
                
                // Check if the widget is still mounted after the async call
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Kitchen'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.gear),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
              );
            },
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemOptions(context); // Call the method to show options
        },
        backgroundColor: Colors.teal,
        child: const FaIcon(FontAwesomeIcons.plus, size: 30),
      ),
    );
  }
}