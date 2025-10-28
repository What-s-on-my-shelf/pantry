import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/inventory_item.dart';
import '../services/inventory_manager.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;

  const InventoryListItem({super.key, required this.item});

  void _editExpirationDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: item.expirationDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<InventoryManager>(context, listen: false)
            .updateExpirationDate(item.id, pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryManager = Provider.of<InventoryManager>(context, listen: false);

    // 1. Wrap the entire Card with a Dismissible widget
    return Dismissible(
      key: ValueKey(item.id), // A unique key is required for each item
      direction: DismissDirection.endToStart, // Allow swiping from right to left
      
      // 2. Define what happens when the item is swiped away
      onDismissed: (direction) {
        // Set quantity to 0 to trigger the existing removal logic
        inventoryManager.updateItemQuantity(item.id, 0);
        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name} deleted')),
        );
      },
      
      // 3. This is the red background with the trash icon that appears during the swipe
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
      ),
      
      // 4. The original Card is now the child of the Dismissible
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[700],
            child: Text(item.name[0]),
          ),
          title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: InkWell(
            onTap: () => _editExpirationDate(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Expires: ${DateFormat.yMd().format(item.expirationDate)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 8),
                  const FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.white54),
                ],
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.circleMinus, color: Colors.teal),
                onPressed: () {
                  inventoryManager.updateItemQuantity(item.id, item.quantity - 1);
                },
              ),
              Text(
                item.quantity.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.circlePlus, color: Colors.teal),
                onPressed: () {
                  inventoryManager.updateItemQuantity(item.id, item.quantity + 1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}