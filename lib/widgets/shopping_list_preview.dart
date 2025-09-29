import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import '../models/shopping_list.dart'; // We need this model

class ShoppingListPreview extends StatelessWidget {
  const ShoppingListPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingLists = Provider.of<InventoryManager>(context).shoppingLists;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Shopping Lists:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: shoppingLists.length,
            itemBuilder: (context, index) {
              final list = shoppingLists[index];
              return _buildShoppingListCard(list.storeName, list.items);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingListCard(String storeName, List<ShoppingListItem> items) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Take the first 3 items to not overflow the card
            ...items.take(3).map((item) => Text(
              '- ${item.name}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            )),
          ],
        ),
      ),
    );
  }
}