import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import '../widgets/shopping_checklist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key});

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final manager = Provider.of<InventoryManager>(context, listen: false);
    _tabController = TabController(length: manager.shoppingLists.length, vsync: this);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final manager = Provider.of<InventoryManager>(context);
    if (manager.shoppingLists.length != _tabController.length) {
      // Re-create the TabController with the new length
      // Save the old index to try and restore it
      final oldIndex = _tabController.index;
      _tabController.dispose(); // Dispose the old controller
      setState(() {
         _tabController = TabController(
           length: manager.shoppingLists.length,
           vsync: this,
           // Set the initial index to the old one if it's still valid
           initialIndex: oldIndex < manager.shoppingLists.length ? oldIndex : 0,
         );
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _showAddListDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New List'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Store Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<InventoryManager>(context, listen: false)
                    .createNewShoppingList(nameController.text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  // --- NEW METHOD TO CONFIRM AND DELETE A LIST ---
  void _confirmDeleteList() {
    final manager = Provider.of<InventoryManager>(context, listen: false);
    // Get the name of the currently selected list
    final storeName = manager.shoppingLists[_tabController.index].storeName;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text('Do you want to permanently delete the "$storeName" list?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              manager.deleteShoppingList(storeName);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<InventoryManager>(context);
    final shoppingLists = manager.shoppingLists;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        backgroundColor: Colors.grey[900],
        // --- ADD THE ACTIONS PROPERTY FOR THE DELETE BUTTON ---
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.redAccent),
            onPressed: shoppingLists.isEmpty ? null : _confirmDeleteList,
          ),
        ],
        bottom: shoppingLists.isEmpty 
          ? null 
          : TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: shoppingLists.map((list) => Tab(text: list.storeName)).toList(),
            ),
      ),
      body: shoppingLists.isEmpty
          ? const Center(child: Text("No shopping lists yet. Add one!"))
          : TabBarView(
              controller: _tabController,
              children: shoppingLists.map((list) => ShoppingChecklist(shoppingList: list)).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddListDialog,
        backgroundColor: Colors.teal,
        child: const FaIcon(FontAwesomeIcons.plus, size: 30), // <-- UPDATE THIS LINE
),
    );
  }
}