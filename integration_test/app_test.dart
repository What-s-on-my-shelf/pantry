import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pantry/main.dart' as app; // Import your main file

void main() {
  // 1. Initialize the IntegrationTestWidgetsFlutterBinding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tap add button opens options sheet', (WidgetTester tester) async {
    // 2. Start the app
    // Note: We call your main() function. Since it's async in your app,
    // we just run the app initialization logic.
    await app.main();
    
    // 3. Wait for the app to settle (finish animations, loading, etc.)
    await tester.pumpAndSettle();

    // 4. Find the Floating Action Button (the + icon)
    // We use a Finder to locate the button by its Type or Icon
    final fab = find.byType(FloatingActionButton);

    // 5. Tap the FAB
    await tester.tap(fab);

    // 6. Wait for the bottom sheet animation to finish
    await tester.pumpAndSettle();

    // 7. Verify the "Enter Manually" option is now visible
    expect(find.text('Enter Manually'), findsOneWidget);
    expect(find.text('Scan Barcode'), findsOneWidget);
  });
}