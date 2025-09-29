import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/tabs_screen.dart';
import 'services/inventory_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The ChangeNotifierProvider makes the InventoryManager available to all
    // widgets in the app.
    return ChangeNotifierProvider(
      create: (context) => InventoryManager(),
      child: MaterialApp(
        title: 'Kitchen Inventory',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const TabsScreen(), // Was previously HomeScreen()
      ),
    );
  }
}