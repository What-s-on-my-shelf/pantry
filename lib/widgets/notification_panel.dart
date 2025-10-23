import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/inventory_manager.dart';
import '../services/settings_manager.dart';

class NotificationPanel extends StatelessWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<InventoryManager, SettingsManager>(
      builder: (context, inventoryManager, settingsManager, child) {
        
        final expiringItems = inventoryManager.getExpiringItems(
          withinDays: settingsManager.expirationWarningDays,
        );

        return Column(
          children: [
            ...expiringItems.map((item) {
              final daysLeft = item.expirationDate.difference(DateTime.now()).inDays;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: NotificationRow(
                  text: '${item.name} will expire in ${daysLeft + 1} days',
                  color: Colors.red,
                  icon: FontAwesomeIcons.triangleExclamation,
                ),
              );
            }).toList(),

            const NotificationRow(
              text: 'Click here for recipes to use these ingredients',
              color: Colors.green,
              icon: FontAwesomeIcons.faceSmile,
            ),
          ],
        );
      },
    );
  }
}

class NotificationRow extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const NotificationRow({
    super.key,
    required this.text,
    required this.color,
    this.icon = FontAwesomeIcons.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, color: color, size: 16),
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