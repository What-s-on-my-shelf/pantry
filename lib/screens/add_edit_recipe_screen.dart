import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/inventory_manager.dart';

class AddEditRecipeScreen extends StatefulWidget {
  // 1. Add an optional recipe property
  final Recipe? recipe;

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _recipeNameController = TextEditingController();
  final List<Map<String, TextEditingController>> _ingredientControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _recipeNameController.text = widget.recipe!.name;
      for (var ingredient in widget.recipe!.ingredients.entries) {
        _addIngredientField(name: ingredient.key, quantity: ingredient.value.toString());
      }
    } else {
      _addIngredientField();
    }
  }

  void _addIngredientField({String name = '', String quantity = ''}) {
    setState(() {
      _ingredientControllers.add({
        'name': TextEditingController(text: name),
        'quantity': TextEditingController(text: quantity),
      });
    });
  }

  void _removeIngredientField(int index) {
    _ingredientControllers[index]['name']!.dispose();
    _ingredientControllers[index]['quantity']!.dispose();
    setState(() {
      _ingredientControllers.removeAt(index);
    });
  }
  
  void _saveRecipe() {
    final recipeName = _recipeNameController.text;
    if (recipeName.isEmpty) return;

    final Map<String, int> ingredients = {};
    for (var controllerPair in _ingredientControllers) {
      final name = controllerPair['name']!.text;
      final quantity = int.tryParse(controllerPair['quantity']!.text);
      if (name.isNotEmpty && quantity != null && quantity > 0) {
        ingredients[name] = quantity;
      }
    }

    if (ingredients.isEmpty) return;
    
    final manager = Provider.of<InventoryManager>(context, listen: false);

    if (widget.recipe != null) {
      manager.editRecipe(widget.recipe!.id, recipeName, ingredients);
    } else {
      manager.addRecipe(recipeName, ingredients);
    }
    // Pop twice if editing to get back to the main recipe list
    Navigator.of(context).pop();
    if (widget.recipe != null) {
      Navigator.of(context).pop();
    }
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

  // --- THIS IS THE MISSING METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.recipe == null ? 'Add New Recipe' : 'Edit Recipe'),
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
                        icon: const FaIcon(FontAwesomeIcons.trashCan, color: Colors.red),
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
