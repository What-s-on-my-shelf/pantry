import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/tabs_screen.dart';
import 'services/inventory_manager.dart';
import 'services/settings_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsManager = SettingsManager();
  await settingsManager.loadSettings();

  // This is the line that needs to pass the argument
  runApp(MyApp(settingsManager: settingsManager)); 
}

class MyApp extends StatelessWidget {
  final SettingsManager settingsManager;
  
  // This is the constructor that requires the argument
  const MyApp({super.key, required this.settingsManager});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InventoryManager()),
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