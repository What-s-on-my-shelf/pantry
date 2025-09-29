class InventoryItem {
  final String id;
  String name;
  int quantity;
  DateTime purchaseDate;
  DateTime expirationDate;
  String category;
  String? imageUrl; // Optional image URL

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchaseDate,
    required this.expirationDate,
    this.category = 'General',
    this.imageUrl,
  });
}