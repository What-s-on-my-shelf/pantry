import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/inventory_item.dart';
import '../services/inventory_manager.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;

  const InventoryListItem({super.key, required this.item});

  void _editExpirationDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: item.expirationDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Can select past dates
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        // Use Provider to call the update method
        Provider.of<InventoryManager>(context, listen: false)
            .updateExpirationDate(item.id, pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get a reference to the manager for our buttons
    final inventoryManager = Provider.of<InventoryManager>(context, listen: false);

    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        // Leading section for an image (optional)
        leading: CircleAvatar(
          backgroundColor: Colors.grey[700],
          child: Text(item.name[0]), // Display first letter of the name
        ),

        // Title is the item name
        title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

        // Subtitle for the editable expiration date
        subtitle: InkWell(
          onTap: () => _editExpirationDate(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Makes it easier to tap
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Expires: ${DateFormat.yMd().format(item.expirationDate)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, size: 16, color: Colors.white54),
              ],
            ),
          ),
        ),

        // Trailing section for the quantity stepper
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Keep the row compact
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.teal),
              onPressed: () {
                inventoryManager.updateItemQuantity(item.id, item.quantity - 1);
              },
            ),
            Text(
              item.quantity.toString(),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.teal),
              onPressed: () {
                inventoryManager.updateItemQuantity(item.id, item.quantity + 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}