import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/tabs_screen.dart';
import 'services/inventory_manager.dart';
import 'services/settings_manager.dart';

Future<void> main() async {
  // 1. Ensure all plugins are ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Create instances of both managers
  final settingsManager = SettingsManager();
  final inventoryManager = InventoryManager();

  // 3. Load all data from the device *before* the app runs
  await settingsManager.loadSettings();
  await inventoryManager.loadData(); // <-- ADD THIS LINE

  // 4. Pass both managers to the app
  runApp(MyApp(
    settingsManager: settingsManager,
    inventoryManager: inventoryManager,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsManager settingsManager;
  final InventoryManager inventoryManager;
  
  const MyApp({
    super.key, 
    required this.settingsManager,
    required this.inventoryManager,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 5. Provide the already-loaded instances
        ChangeNotifierProvider.value(value: inventoryManager),
        ChangeNotifierProvider.value(value: settingsManager),
      ],
      child: MaterialApp(
        title: 'Kitchen Inventory',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal,
            secondary: Colors.tealAccent,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.grey[850],
            headerBackgroundColor: Colors.teal,
            headerForegroundColor: Colors.white,
            dayForegroundColor: MaterialStateProperty.all(Colors.white),
            yearForegroundColor: MaterialStateProperty.all(Colors.white),
            todayBorder: const BorderSide(color: Colors.tealAccent),
          ),
        ),
        home: const TabsScreen(),
      ),
    );
  }
}