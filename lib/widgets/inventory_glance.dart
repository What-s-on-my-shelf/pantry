import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';

class InventoryGlance extends StatelessWidget {
  const InventoryGlance({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryManager>(context).inventory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your inventory at a glance',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: inventory.length,
            itemBuilder: (context, index) {
              final item = inventory[index];
              return Card(
                color: Colors.grey[800],
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(item.name, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}