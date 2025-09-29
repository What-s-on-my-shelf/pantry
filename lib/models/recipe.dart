class Recipe {
  final String id;
  String name;
  Map<String, int> ingredients; // Key: Item Name, Value: Quantity

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
  });
}