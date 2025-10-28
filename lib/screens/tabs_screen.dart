import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Make sure this is added
import 'home_screen.dart'; // This is the line to add
import 'inventory_screen.dart';
import 'recipes_screen.dart';
import 'shopping_lists_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // A list of the screens to be displayed
  final List<Widget> _pages = [
    const HomeScreen(),
    const InventoryScreen(), // The new full inventory screen
    const RecipesScreen(),
    const ShoppingListsScreen(),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.grey[900],
        unselectedItemColor: Colors.white38,
        selectedItemColor: Colors.teal,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed, // Keeps all labels visible
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house), // Using new icon
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.warehouse), // Using new icon
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookOpen), // Using new icon
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cartShopping), // Using new icon
            label: 'Lists',
          ),
        ],
      ),
    );
  }
}