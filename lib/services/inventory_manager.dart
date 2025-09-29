import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../models/recipe.dart';
import '../models/shopping_list.dart';

class InventoryManager extends ChangeNotifier {
  // PRIVATE LISTS TO HOLD THE STATE
  final List<InventoryItem> _inventory = [];
  final List<Recipe> _recipes = [];
  final List<ShoppingList> _shoppingLists = [];

  // PUBLIC GETTERS TO ACCESS THE DATA
  List<InventoryItem> get inventory => _inventory;
  List<Recipe> get recipes => _recipes;
  List<ShoppingList> get shoppingLists => _shoppingLists;
  
  // CONSTRUCTOR TO POPULATE WITH SAMPLE DATA
 InventoryManager() {
   _addSampleData();
   _addSampleRecipes(); // <-- ADD THIS LINE
 }

  void _addSampleData() {
    // Sample Inventory Items
    _inventory.addAll([
      InventoryItem(id: '1', name: 'Milk', quantity: 1, purchaseDate: DateTime.now().subtract(const Duration(days: 1)), expirationDate: DateTime.now().add(const Duration(days: 2))),
      InventoryItem(id: '2', name: 'Chicken Breast', quantity: 2, purchaseDate: DateTime.now().subtract(const Duration(days: 1)), expirationDate: DateTime.now().add(const Duration(days: 4))),
      InventoryItem(id: '3', name: 'Block of Cheese', quantity: 1, purchaseDate: DateTime.now().subtract(const Duration(days: 65)), expirationDate: DateTime.now().add(const Duration(days: 20))),
      InventoryItem(id: '4', name: 'Apples', quantity: 5, purchaseDate: DateTime.now(), expirationDate: DateTime.now().add(const Duration(days: 10))),
    ]);

    // Sample Shopping Lists
    _shoppingLists.addAll([
      ShoppingList(storeName: 'King Sooper', items: [
        ShoppingListItem(name: 'Cream cheese'),
        ShoppingListItem(name: 'Ham'),
        ShoppingListItem(name: 'Pork Chops'),
      ]),
      ShoppingList(storeName: "Sam's Club", items: [
        ShoppingListItem(name: 'Mixed Nuts'),
        ShoppingListItem(name: 'Lucky Charms'),
        ShoppingListItem(name: 'Beef Jerky'),
      ])
    ]);
  }

  // --- LOGIC METHODS ---
  List<InventoryItem> getExpiringItems({int withinDays = 5}) {
    final now = DateTime.now();
    return _inventory.where((item) {
      final difference = item.expirationDate.difference(now).inDays;
      return difference >= 0 && difference <= withinDays;
    }).toList();
  }
// Add this new method inside your InventoryManager class

void removeFromShoppingList(String storeName, ShoppingListItem itemToRemove) {
  try {
    final list = _shoppingLists.firstWhere((sl) => sl.storeName == storeName);
    list.items.remove(itemToRemove);
    notifyListeners();
  } catch (e) {
    // List not found, do nothing
  }
}
void updateItemQuantity(String itemId, int newQuantity) {
  try {
    final item = _inventory.firstWhere((item) => item.id == itemId);
    if (newQuantity <= 0) {
      _inventory.remove(item);
    } else {
      item.quantity = newQuantity;
    }
    notifyListeners();
  } catch (e) {
    // Item not found, do nothing
  }
}

void updateExpirationDate(String itemId, DateTime newDate) {
  try {
    final item = _inventory.firstWhere((item) => item.id == itemId);
    item.expirationDate = newDate;
    notifyListeners();
  } catch (e) {
    // Item not found, do nothing
  }
}

// --- RECIPE LOGIC ---

void _addSampleRecipes() {
  _recipes.add(
    Recipe(id: 'r1', name: 'Scrambled Eggs', ingredients: {'Milk': 1, 'Block of Cheese': 1, 'Eggs': 2})
  );
  _recipes.add(
    Recipe(id: 'r2', name: 'Chicken Sandwich', ingredients: {'Chicken Breast': 1, 'Bread': 2})
  );
}

// A helper method to check if we have enough of a specific item
int getQuantityOf(String itemName) {
  try {
    return _inventory.firstWhere((item) => item.name.toLowerCase() == itemName.toLowerCase()).quantity;
  } catch (e) {
    return 0; // Return 0 if item not found
  }
}

void addRecipe(String name, Map<String, int> ingredients) {
  final newRecipe = Recipe(
    id: DateTime.now().toIso8601String(),
    name: name,
    ingredients: ingredients,
  );
  _recipes.add(newRecipe);
  notifyListeners();
}

// Method to "cook" a recipe and deduct ingredients
String consumeRecipe(Recipe recipe) {
  // First, check if all ingredients are available
  for (var entry in recipe.ingredients.entries) {
    final itemName = entry.key;
    final quantityNeeded = entry.value;
    if (getQuantityOf(itemName) < quantityNeeded) {
      return 'You are missing $itemName!'; // Return an error message
    }
  }

  // If all ingredients are available, deduct them
  for (var entry in recipe.ingredients.entries) {
    final itemInInventory = _inventory.firstWhere((i) => i.name.toLowerCase() == entry.key.toLowerCase());
    updateItemQuantity(itemInInventory.id, itemInInventory.quantity - entry.value);
  }
  
  // No need to call notifyListeners() here, since updateItemQuantity already does.
  return 'Enjoy your ${recipe.name}!'; // Return a success message
}
  // vvv THIS IS THE METHOD THAT WAS MISSING vvv
  void addItem(String name, int quantity, DateTime expirationDate) {
    final newItem = InventoryItem(
      // Using the current timestamp for a simple unique ID
      id: DateTime.now().toIso8601String(),
      name: name,
      quantity: quantity,
      purchaseDate: DateTime.now(),
      expirationDate: expirationDate,
    );
    _inventory.add(newItem);
    
    // This tells all listening widgets to rebuild.
    notifyListeners();
  }
}