import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/inventory_item.dart';
import '../models/recipe.dart';
import '../models/shopping_list.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // --- 1. CREATE ALL THE TABLES ---
  Future _createDB(Database db, int version) async {
    // Inventory Item Table
    await db.execute('''
      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        purchaseDate TEXT NOT NULL,
        expirationDate TEXT NOT NULL,
        category TEXT,
        imageUrl TEXT
      )
    ''');

    // Recipe Table
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        ingredients TEXT NOT NULL 
      )
    ''');
    
    // Shopping List Table
    await db.execute('''
      CREATE TABLE shopping_lists (
        storeName TEXT PRIMARY KEY, 
        items TEXT NOT NULL
      )
    ''');
  }

  // --- 2. INVENTORY ITEM CRUD OPERATIONS ---
  Future<void> insertItem(InventoryItem item) async {
    final db = await instance.database;
    await db.insert('inventory', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<InventoryItem>> getAllItems() async {
    final db = await instance.database;
    final maps = await db.query('inventory');
    if (maps.isEmpty) return [];
    return maps.map((map) => InventoryItem.fromMap(map)).toList();
  }

  Future<void> updateItem(InventoryItem item) async {
    final db = await instance.database;
    await db.update('inventory', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<void> deleteItem(String id) async {
    final db = await instance.database;
    await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }

  // --- 3. RECIPE CRUD OPERATIONS ---
  Future<void> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert('recipes', recipe.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes');
    if (maps.isEmpty) return [];
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.update('recipes', recipe.toMap(), where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<void> deleteRecipe(String id) async {
    final db = await instance.database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  // --- 4. SHOPPING LIST CRUD OPERATIONS ---
  Future<void> insertShoppingList(ShoppingList list) async {
    final db = await instance.database;
    await db.insert('shopping_lists', list.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ShoppingList>> getAllShoppingLists() async {
    final db = await instance.database;
    final maps = await db.query('shopping_lists');
    if (maps.isEmpty) return [];
    return maps.map((map) => ShoppingList.fromMap(map)).toList();
  }
  
  Future<void> deleteShoppingList(String storeName) async {
    final db = await instance.database;
    await db.delete('shopping_lists', where: 'storeName = ?', whereArgs: [storeName]);
  }
}