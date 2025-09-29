import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import 'recipe_detail_screen.dart'; // Will create next
import 'add_edit_recipe_screen.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<InventoryManager>(context);
    final recipes = manager.recipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(recipe.name, style: const TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => RecipeDetailScreen(recipe: recipe)),
                );
              },
            ),
          );
        },
      ),
floatingActionButton: FloatingActionButton(
  onPressed: () {
    // 2. Navigate to the AddEditRecipeScreen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddEditRecipeScreen()),
    );
  },
  backgroundColor: Colors.teal,
  child: const Icon(Icons.add),
),
    );
  }
}