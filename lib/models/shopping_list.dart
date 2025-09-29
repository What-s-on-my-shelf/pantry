class ShoppingListItem {
  final String name;
  int quantity;
  bool isPurchased;

  ShoppingListItem({
    required this.name,
    this.quantity = 1,
    this.isPurchased = false,
  });
}

class ShoppingList {
  final String storeName;
  final List<ShoppingListItem> items;

  ShoppingList({
    required this.storeName,
    required this.items,
  });
}