import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pantry/models/inventory_item.dart';
import 'package:pantry/services/inventory_manager.dart';
import 'package:pantry/widgets/inventory_list_item.dart';

void main() {
  testWidgets('InventoryListItem displays name and quantity', (WidgetTester tester) async {
    // 1. ARRANGE: Create a sample item to display
    final testItem = InventoryItem(
      id: '123',
      name: 'Golden Apples',
      quantity: 5,
      purchaseDate: DateTime.now(),
      expirationDate: DateTime.now().add(const Duration(days: 7)),
      category: 'Fruit',
    );

    // 2. ACT: Build the widget in the test environment
    // We must wrap it in MultiProvider and MaterialApp because the widget 
    // looks for the Theme and the InventoryManager.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => InventoryManager()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: InventoryListItem(item: testItem),
          ),
        ),
      ),
    );

    // 3. ASSERT: Check if the text appears on screen
    
    // Look for the item name
    expect(find.text('Golden Apples'), findsOneWidget);
    
    // Look for the quantity (converted to string)
    expect(find.text('5'), findsOneWidget);
    
    // Verify that the "Expires" text is present (we match partial text)
    expect(find.textContaining('Expires:'), findsOneWidget);
  });
}