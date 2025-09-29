import 'package:flutter/material.dart'; // Correct: package:flutter
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';

class AddEditRecipeScreen extends StatefulWidget {
  const AddEditRecipeScreen({super.key});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _recipeNameController = TextEditingController();
  
  // List to hold a pair of controllers for each ingredient
  final List<Map<String, TextEditingController>> _ingredientControllers = [];

  @override
  void initState() {
    super.initState();
    // Start with one empty ingredient field
    _addIngredientField();
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add({
        'name': TextEditingController(),
        'quantity': TextEditingController(),
      });
    });
  }

  void _removeIngredientField(int index) {
    // First, dispose the controllers to prevent memory leaks
    _ingredientControllers[index]['name']!.dispose();
    _ingredientControllers[index]['quantity']!.dispose();
    setState(() {
      _ingredientControllers.removeAt(index);
    });
  }
  
  void _saveRecipe() {
    final recipeName = _recipeNameController.text;
    if (recipeName.isEmpty) return; // Basic validation

    final Map<String, int> ingredients = {};
    for (var controllerPair in _ingredientControllers) {
      final name = controllerPair['name']!.text;
      final quantity = int.tryParse(controllerPair['quantity']!.text);
      if (name.isNotEmpty && quantity != null && quantity > 0) {
        ingredients[name] = quantity;
      }
    }

    if (ingredients.isEmpty) return; // More validation

    Provider.of<InventoryManager>(context, listen: false).addRecipe(recipeName, ingredients);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    for (var controllerPair in _ingredientControllers) {
      controllerPair['name']!.dispose();
      controllerPair['quantity']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Recipe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecipe,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _recipeNameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Ingredients', style: TextStyle(fontSize: 18, color: Colors.white)),
            Expanded(
              child: ListView.builder(
                itemCount: _ingredientControllers.length,
                itemBuilder: (ctx, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _ingredientControllers[index]['name'],
                          decoration: const InputDecoration(labelText: 'Name'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _ingredientControllers[index]['quantity'],
                          decoration: const InputDecoration(labelText: 'Qty'),
                          keyboardType: TextInputType.number,
                           style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeIngredientField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Ingredient'),
              onPressed: _addIngredientField,
            ),
          ],
        ),
      ),
    );
  }
}