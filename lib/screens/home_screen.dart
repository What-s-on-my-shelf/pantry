import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pantry/screens/add_edit_recipe_screen.dart';
import '../widgets/inventory_glance.dart';
import '../widgets/notification_panel.dart';
import '../widgets/shopping_list_preview.dart';
import 'add_item_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        // The actions property can be restored later
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const AddItemScreen()),
          );
        },
        backgroundColor: Colors.teal,
        child: const FaIcon(FontAwesomeIcons.plus, size: 30),
      ),
    );
  }
}