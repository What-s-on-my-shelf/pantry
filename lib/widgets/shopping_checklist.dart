import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list.dart';
import '../services/inventory_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 1. Convert this to a StatefulWidget
class ShoppingChecklist extends StatefulWidget {
  final ShoppingList shoppingList;
  const ShoppingChecklist({super.key, required this.shoppingList});

  @override
  State<ShoppingChecklist> createState() => _ShoppingChecklistState();
}

class _ShoppingChecklistState extends State<ShoppingChecklist> {
  final _itemController = TextEditingController();

  void _onItemChecked(BuildContext context, ShoppingListItem item) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        final manager = Provider.of<InventoryManager>(context, listen: false);
        manager.addItem(item.name, item.quantity, pickedDate);
        manager.removeFromShoppingList(widget.shoppingList.storeName, item);
      }
    });
  }

  void _addItemToList() {
    if (_itemController.text.isEmpty) return;
    Provider.of<InventoryManager>(context, listen: false).addItemToShoppingList(
      widget.shoppingList.storeName,
      _itemController.text,
      1, // Default quantity to 1
    );
    _itemController.clear();
    FocusScope.of(context).unfocus(); // Hide keyboard
  }
  
  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.shoppingList to access the data
    return Column(
      children: [
        // 2. Add the input form at the top
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(labelText: 'Add Item'),
                   style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.pencil, color: Colors.teal),
                onPressed: _addItemToList,
              )
            ],
          ),
        ),
        const Divider(),
        // 3. Make the list expand to fill the rest of the space
        Expanded(
          child: ListView.builder(
            itemCount: widget.shoppingList.items.length,
            itemBuilder: (ctx, index) {
              final item = widget.shoppingList.items[index];
              return CheckboxListTile(
                title: Text('${item.name} (Qty: ${item.quantity})', style: const TextStyle(color: Colors.white)),
                value: item.isPurchased,
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
          ),
        ),
      ],
    );
  }
}