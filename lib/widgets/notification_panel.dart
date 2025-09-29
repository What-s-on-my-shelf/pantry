import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';

class NotificationPanel extends StatelessWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the InventoryManager
    final inventoryManager = Provider.of<InventoryManager>(context);
    final expiringItems = inventoryManager.getExpiringItems();

    return Column(
      children: [
        // Dynamically create a row for each expiring item
        ...expiringItems.map((item) {
          final daysLeft = item.expirationDate.difference(DateTime.now()).inDays;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: NotificationRow(
              text: '${item.name} will expire in ${daysLeft + 1} days',
              color: Colors.red,
            ),
          );
        }).toList(),

        // The static recipe suggestion row
        const NotificationRow(
          text: 'Click here for recipes to use these ingredients',
          color: Colors.green,
          icon: Icons.arrow_forward_ios,
        ),
      ],
    );
  }
}

// Helper widget remains the same
class NotificationRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const NotificationRow({
    super.key,
    required this.text,
    required this.color,
    this.icon = Icons.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}