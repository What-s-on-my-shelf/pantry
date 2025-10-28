import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';
import 'recipe_detail_screen.dart'; // Will create next
import 'add_edit_recipe_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  // 1. Wrap the Card with a Dismissible widget
          return Dismissible(
            key: ValueKey(recipe.id), // A unique key is required
            direction: DismissDirection.endToStart, // Swipe from right to left
            onDismissed: (direction) {
              manager.deleteRecipe(recipe.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${recipe.name} deleted')),
              );
    },
    // 2. This is the background that appears during the swipe
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.white),
            ),
    // 3. This is your original Card/ListTile
            child: Card(
              color: Colors.grey[850],
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                title: Text(recipe.name, style: const TextStyle(color: Colors.white)),
                trailing: const FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white54),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => RecipeDetailScreen(recipe: recipe)),
                  );
        },
      ),
    ),
  );
},
      ),
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddEditRecipeScreen()),
    );
  },
  backgroundColor: Colors.teal,
  child: const FaIcon(FontAwesomeIcons.plus, size: 30), // <-- UPDATE THIS LINE
),
    );
  }
}