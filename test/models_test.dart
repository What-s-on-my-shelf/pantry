import 'package:flutter_test/flutter_test.dart';
import 'package:pantry/models/inventory_item.dart';
import 'package:pantry/models/recipe.dart';

void main() {
  group('InventoryItem Tests', () {
    test('should convert InventoryItem to Map correctly', () {
      // 1. Arrange: Create a sample item
      final date = DateTime.now();
      final item = InventoryItem(
        id: '123',
        name: 'Test Milk',
        quantity: 2,
        purchaseDate: date,
        expirationDate: date,
        category: 'Dairy',
      );

      // 2. Act: Convert it to a map
      final map = item.toMap();

      // 3. Assert: Check if the map has the right data
      expect(map['id'], '123');
      expect(map['name'], 'Test Milk');
      expect(map['quantity'], 2);
      expect(map['category'], 'Dairy');
      // Check if dates were converted to string
      expect(map['purchaseDate'], date.toIso8601String());
    });

    test('should create InventoryItem from Map correctly', () {
      // 1. Arrange: Create a sample map (simulating DB data)
      final date = DateTime.now();
      final map = {
        'id': '456',
        'name': 'Test Eggs',
        'quantity': 12,
        'purchaseDate': date.toIso8601String(),
        'expirationDate': date.toIso8601String(),
        'category': 'Dairy',
        'imageUrl': null,
      };

      // 2. Act: Convert map back to object
      final item = InventoryItem.fromMap(map);

      // 3. Assert: Check if the object is correct
      expect(item.id, '456');
      expect(item.name, 'Test Eggs');
      expect(item.quantity, 12);
      // Check if date string was converted back to DateTime
      expect(item.purchaseDate.year, date.year);
      expect(item.purchaseDate.minute, date.minute);
    });
  });

  group('Recipe Tests', () {
    test('should convert Recipe ingredients to JSON string', () {
      // 1. Arrange
      final recipe = Recipe(
        id: 'r1',
        name: 'Toast',
        ingredients: {'Bread': 2, 'Butter': 1},
      );

      // 2. Act
      final map = recipe.toMap();

      // 3. Assert
      expect(map['name'], 'Toast');
      // Verify ingredients became a string
      expect(map['ingredients'], isA<String>());
      expect(map['ingredients'], contains('Bread'));
    });
  });
}