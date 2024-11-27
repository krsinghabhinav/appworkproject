import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._internal(); //singlton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  // Open database connection
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    //getDatabasesPath()== Ye method application-specific database directory ka path return karta hai.
    // Is directory ka use aap databases ko store karne ke liye karte hain (e.g., SQLite databases).
    //     Use Case:
    // Database files (e.g., SQLite ya custom database formats) store karna.
    // Backend data (e.g., tables or records) ka storage.
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'invoice_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  // Create tables for customers and products
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        product TEXT,
        price REAL,
        FOREIGN KEY (customerId) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert a new customer
  Future<int> insertCustomer(String name) async {
    final db = await database;
    return await db.insert('customers', {'name': name});
  }

  // Insert a new product
  Future<int> insertProduct(
      int customerId, String product, double price) async {
    final db = await database;
    return await db.insert(
      'products',
      {'customerId': customerId, 'product': product, 'price': price},
    );
  }

  // Fetch all customers
  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final db = await database;
    return await db.query('customers');
  }

  // Fetch all products for a specific customer
  Future<List<Map<String, dynamic>>> fetchProducts(int customerId) async {
    final db = await database;
    return await db
        .query('products', where: 'customerId = ?', whereArgs: [customerId]);
  }
}
