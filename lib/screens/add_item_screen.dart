import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/inventory_manager.dart';

class AddItemScreen extends StatefulWidget {
  // 1. Add an optional barcode field
  final String? barcode;

  const AddItemScreen({super.key, this.barcode});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? _selectedDate;

  // 2. Add initState to pre-fill the form
  @override
  void initState() {
    super.initState();
    if (widget.barcode != null) {
      // In a real app, you'd call an API here to get the product name
      // For now, we just put the barcode number in the name field
      _nameController.text = "Scanned: ${widget.barcode!}";
    }
  }

  // ... (keep _presentDatePicker and _submitData methods exactly as they are) ...
  
  // (Paste your existing _presentDatePicker method here)
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 years from now
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // (Paste your existing _submitData method here)
  void _submitData() {
    final enteredName = _nameController.text;
    final enteredQuantity = int.tryParse(_quantityController.text);

    // Basic validation
    if (enteredName.isEmpty || enteredQuantity == null || enteredQuantity <= 0 || _selectedDate == null) {
      // You can show an error dialog here
      return;
    }
    
    Provider.of<InventoryManager>(context, listen: false)
      .addItem(enteredName, enteredQuantity, _selectedDate!);
      
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    // ... (rest of the build method is the same)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Expiration Date Chosen'
                        : 'Expires: ${DateFormat.yMd().format(_selectedDate!)}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Spacer(), 
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Item'),
            ),
          ],
        ),
      ),
    );
  }
}