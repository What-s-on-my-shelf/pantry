class InventoryItem {
  final String id;
  String name;
  int quantity;
  DateTime purchaseDate;
  DateTime expirationDate;
  String category;
  String? imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchaseDate,
    required this.expirationDate,
    this.category = 'General',
    this.imageUrl,
  });

  // --- ADD THIS METHOD ---
  // Converts this object into a Map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'purchaseDate': purchaseDate.toIso8601String(), // Convert DateTime to text
      'expirationDate': expirationDate.toIso8601String(), // Convert DateTime to text
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  // --- AND ADD THIS CONSTRUCTOR ---
  // Creates an InventoryItem from a Map (read from the database)
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      purchaseDate: DateTime.parse(map['purchaseDate']), // Convert text back to DateTime
      expirationDate: DateTime.parse(map['expirationDate']), // Convert text back to DateTime
      category: map['category'],
      imageUrl: map['imageUrl'],
    );
  }
}