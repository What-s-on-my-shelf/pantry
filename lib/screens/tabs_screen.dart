import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'inventory_screen.dart'; 
import 'recipes_screen.dart';
import 'shopping_lists_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // A list of the screens to be displayed
final List<Widget> _pages = [
    const HomeScreen(),
    const InventoryScreen(),
    const RecipesScreen(), // <-- Replace the placeholder
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
          icon: FaIcon(FontAwesomeIcons.house), // <-- Replace Icon(Icons.dashboard)
          label: 'Dashboard',
  ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.warehouse),
            label: 'Inventory',
  ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookOpen),
            label: 'Recipes',
  ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cartShopping),
            label: 'Lists',
  ),
],
      ),
    );
  }
}