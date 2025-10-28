import 'dart:convert'; // <-- 1. ADD THIS IMPORT

class ShoppingListItem {
  final String name;
  int quantity;
  bool isPurchased;

  ShoppingListItem({
    required this.name,
    this.quantity = 1,
    this.isPurchased = false,
  });

  // --- 2. ADD toMap and fromMap for the ITEM ---
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'isPurchased': isPurchased ? 1 : 0, // Convert bool to integer (1 or 0)
    };
  }

  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      name: map['name'],
      quantity: map['quantity'],
      isPurchased: map['isPurchased'] == 1, // Convert integer back to bool
    );
  }
}

class ShoppingList {
  final String storeName; // This will be our unique ID
  final List<ShoppingListItem> items;

  ShoppingList({
    required this.storeName,
    required this.items,
  });

  // --- 3. ADD toMap and fromMap for the LIST ---
  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      // Convert the list of items into a JSON string
      'items': json.encode(items.map((item) => item.toMap()).toList()),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      storeName: map['storeName'],
      // Parse the JSON string back into a List<ShoppingListItem>
      items: (json.decode(map['items']) as List)
          .map((itemMap) => ShoppingListItem.fromMap(itemMap))
          .toList(),
    );
  }
}