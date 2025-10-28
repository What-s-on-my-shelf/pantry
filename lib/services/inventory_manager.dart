import 'package:flutter/material.dart';
import 'database_helper.dart'; // <-- 1. IMPORT THE DATABASE
import '../models/inventory_item.dart';
import '../models/recipe.dart';
import '../models/shopping_list.dart';

class InventoryManager extends ChangeNotifier {
  // These lists are now a "cache" of what's in the database
  final List<InventoryItem> _inventory = [];
  final List<Recipe> _recipes = [];
  final List<ShoppingList> _shoppingLists = [];

  List<InventoryItem> get inventory => _inventory;
  List<Recipe> get recipes => _recipes;
  List<ShoppingList> get shoppingLists => _shoppingLists;
  
  // 2. The constructor is now empty. No more sample data!
  InventoryManager();

  // --- 3. NEW METHOD TO LOAD ALL DATA FROM DB ---
  Future<void> loadData() async {
    _inventory.addAll(await DatabaseHelper.instance.getAllItems());
    _recipes.addAll(await DatabaseHelper.instance.getAllRecipes());
    _shoppingLists.addAll(await DatabaseHelper.instance.getAllShoppingLists());
    notifyListeners();
  }

  // --- 4. ALL METHODS ARE UPDATED TO SAVE TO DB ---

  // --- Inventory Methods ---
  List<InventoryItem> getExpiringItems({required int withinDays}) {
    final now = DateTime.now();
    return _inventory.where((item) {
      final difference = item.expirationDate.difference(now).inDays;
      return difference >= 0 && difference <= withinDays;
    }).toList();
  }

  Future<void> addItem(String name, int quantity, DateTime expirationDate) async {
    final newItem = InventoryItem(
      id: DateTime.now().toIso8601String(),
      name: name,
      quantity: quantity,
      purchaseDate: DateTime.now(),
      expirationDate: expirationDate,
    );
    _inventory.add(newItem);
    await DatabaseHelper.instance.insertItem(newItem); // <-- SAVE TO DB
    notifyListeners();
  }

  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    try {
      final item = _inventory.firstWhere((item) => item.id == itemId);
      if (newQuantity <= 0) {
        _inventory.remove(item);
        await DatabaseHelper.instance.deleteItem(itemId); // <-- SAVE TO DB
      } else {
        item.quantity = newQuantity;
        await DatabaseHelper.instance.updateItem(item); // <-- SAVE TO DB
      }
      notifyListeners();
    } catch (e) {
      // Item not found
    }
  }

  Future<void> updateExpirationDate(String itemId, DateTime newDate) async {
    try {
      final item = _inventory.firstWhere((item) => item.id == itemId);
      item.expirationDate = newDate;
      await DatabaseHelper.instance.updateItem(item); // <-- SAVE TO DB
      notifyListeners();
    } catch (e) {
      // Item not found
    }
  }

  // --- Recipe Methods ---
  int getQuantityOf(String itemName) {
    try {
      return _inventory.firstWhere((item) => item.name.toLowerCase() == itemName.toLowerCase()).quantity;
    } catch (e) {
      return 0;
    }
  }

  Future<void> addRecipe(String name, Map<String, int> ingredients) async {
    final newRecipe = Recipe(
      id: DateTime.now().toIso8601String(),
      name: name,
      ingredients: ingredients,
    );
    _recipes.add(newRecipe);
    await DatabaseHelper.instance.insertRecipe(newRecipe); // <-- SAVE TO DB
    notifyListeners();
  }

  Future<void> editRecipe(String recipeId, String newName, Map<String, int> newIngredients) async {
    try {
      final recipe = _recipes.firstWhere((r) => r.id == recipeId);
      recipe.name = newName;
      recipe.ingredients = newIngredients;
      await DatabaseHelper.instance.updateRecipe(recipe); // <-- SAVE TO DB
      notifyListeners();
    } catch (e) {
      // Recipe not found
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    await DatabaseHelper.instance.deleteRecipe(recipeId); // <-- SAVE TO DB
    notifyListeners();
  }

  String consumeRecipe(Recipe recipe) {
    // This method doesn't need database calls because it uses
    // updateItemQuantity(), which already saves to the database.
    for (var entry in recipe.ingredients.entries) {
      final itemName = entry.key;
      final quantityNeeded = entry.value;
      if (getQuantityOf(itemName) < quantityNeeded) {
        return 'You are missing $itemName!';
      }
    }
    for (var entry in recipe.ingredients.entries) {
      final itemInInventory = _inventory.firstWhere((i) => i.name.toLowerCase() == entry.key.toLowerCase());
      updateItemQuantity(itemInInventory.id, itemInInventory.quantity - entry.value);
    }
    return 'Enjoy your ${recipe.name}!';
  }

  // --- Shopping List Methods ---
  Future<void> createNewShoppingList(String storeName) async {
    if (_shoppingLists.any((list) => list.storeName.toLowerCase() == storeName.toLowerCase())) {
      return;
    }
    final newList = ShoppingList(storeName: storeName, items: []);
    _shoppingLists.add(newList);
    await DatabaseHelper.instance.insertShoppingList(newList); // <-- SAVE TO DB
    notifyListeners();
  }

  Future<void> addItemToShoppingList(String storeName, String itemName, int quantity) async {
    try {
      final list = _shoppingLists.firstWhere((sl) => sl.storeName == storeName);
      list.items.add(ShoppingListItem(name: itemName, quantity: quantity));
      // We save the entire list because the 'items' are stored as JSON
      await DatabaseHelper.instance.insertShoppingList(list); // <-- SAVE TO DB
      notifyListeners();
    } catch (e) {
      // List not found
    }
  }

  Future<void> deleteShoppingList(String storeName) async {
    _shoppingLists.removeWhere((list) => list.storeName == storeName);
    await DatabaseHelper.instance.deleteShoppingList(storeName); // <-- SAVE TO DB
    notifyListeners();
  }

  Future<void> removeFromShoppingList(String storeName, ShoppingListItem itemToRemove) async {
    try {
      final list = _shoppingLists.firstWhere((sl) => sl.storeName == storeName);
      list.items.remove(itemToRemove);
      // We save the entire list because the 'items' are stored as JSON
      await DatabaseHelper.instance.insertShoppingList(list); // <-- SAVE TO DB
      notifyListeners();
    } catch (e) {
      // List not found
    }
  }
}