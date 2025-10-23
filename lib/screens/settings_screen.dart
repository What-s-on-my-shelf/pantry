import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // <-- 1. ADD THIS IMPORT
import '../services/settings_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsManager>(
      builder: (context, settingsManager, child) {
        return Scaffold(
          appBar: AppBar(
            // --- 2. ADD THIS SECTION ---
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // --- END OF NEW SECTION ---
            title: const Text('Settings'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expiration Warning',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Notify me when food will expire within ${settingsManager.expirationWarningDays} days.',
                  style: const TextStyle(color: Colors.white70),
                ),
                Slider(
                  value: settingsManager.expirationWarningDays.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: settingsManager.expirationWarningDays.toString(),
                  onChanged: (double value) {
                    settingsManager.setExpirationWarningDays(value.toInt());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}