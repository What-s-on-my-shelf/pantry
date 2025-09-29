import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/inventory_manager.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<InventoryManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: recipe.ingredients.length,
                itemBuilder: (ctx, index) {
                  final ingredientName = recipe.ingredients.keys.elementAt(index);
                  final requiredQty = recipe.ingredients.values.elementAt(index);
                  final availableQty = manager.getQuantityOf(ingredientName);
                  final haveEnough = availableQty >= requiredQty;

                  return ListTile(
                    leading: Icon(
                      haveEnough ? Icons.check_circle : Icons.cancel,
                      color: haveEnough ? Colors.green : Colors.red,
                    ),
                    title: Text('$requiredQty x $ingredientName', style: const TextStyle(color: Colors.white)),
                    subtitle: Text('You have: $availableQty', style: const TextStyle(color: Colors.white70)),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final result = manager.consumeRecipe(recipe);
                // Show a confirmation or error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result), backgroundColor: result.startsWith('You are missing') ? Colors.red : Colors.green),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cook This Recipe'),
            )
          ],
        ),
      ),
    );
  }
}