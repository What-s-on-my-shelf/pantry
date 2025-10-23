import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'add_edit_recipe_screen.dart';
import '../services/inventory_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<InventoryManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(recipe.name),
        backgroundColor: Colors.grey[900],

      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.penToSquare),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => AddEditRecipeScreen(recipe: recipe),
              ),
            );
          },
        ),
      ],
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
                    // 2. Replace the Icon widget with the FaIcon widget
                    leading: FaIcon(
                      haveEnough ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleXmark,
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