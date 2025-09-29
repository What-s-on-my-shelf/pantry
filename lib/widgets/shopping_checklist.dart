import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list.dart';
import '../services/inventory_manager.dart';

class ShoppingChecklist extends StatelessWidget {
  final ShoppingList shoppingList;
  const ShoppingChecklist({super.key, required this.shoppingList});

  void _onItemChecked(BuildContext context, ShoppingListItem item) {
    // When an item is checked, show a dialog to ask for the expiration date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final manager = Provider.of<InventoryManager>(context, listen: false);
        // 1. Add the item to the main inventory
        manager.addItem(item.name, item.quantity, pickedDate);
        // 2. Remove the item from the shopping list
        manager.removeFromShoppingList(shoppingList.storeName, item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shoppingList.items.length,
      itemBuilder: (ctx, index) {
        final item = shoppingList.items[index];
        return CheckboxListTile(
          title: Text('${item.name} (Qty: ${item.quantity})', style: const TextStyle(color: Colors.white)),
          value: item.isPurchased, // This would need more state if we wanted to un-check
          onChanged: (isChecked) {
            if (isChecked == true) {
              _onItemChecked(context, item);
            }
          },
          activeColor: Colors.teal,
          checkColor: Colors.black,
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}