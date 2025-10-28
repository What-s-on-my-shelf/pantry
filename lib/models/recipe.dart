import 'dart:convert'; // <-- 1. ADD THIS IMPORT for JSON

class Recipe {
  final String id;
  String name;
  Map<String, int> ingredients; // Key: Item Name, Value: Quantity

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
  });

  // --- 2. ADD THIS METHOD ---
  // Converts this object into a Map for saving to the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Convert the Map to a JSON string before saving
      'ingredients': json.encode(ingredients),
    };
  }

  // --- 3. ADD THIS CONSTRUCTOR ---
  // Creates a Recipe from a Map (read from the database)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      // Parse the JSON string back into a Map
      // We must cast the keys as String and values as int
      ingredients: Map<String, int>.from(json.decode(map['ingredients'])),
    );
  }
}