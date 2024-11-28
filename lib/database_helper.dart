import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'invoice.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE customers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerId INTEGER,
            name TEXT,
            price REAL,
            FOREIGN KEY (customerId) REFERENCES customers (id)
          )
        ''');
      },
    );
  }

  Future<int> addCustomer(String name) async {
    Database db = await database;
    return await db.insert('customers', {'name': name});
  }

  Future<int> addProduct(int customerId, String name, double price) async {
    Database db = await database;
    return await db.insert('products', {
      'customerId': customerId,
      'name': name,
      'price': price,
    });
  }

  Future<List<Map<String, dynamic>>> getProducts(int customerId) async {
    Database db = await database;
    return await db
        .query('products', where: 'customerId = ?', whereArgs: [customerId]);
  }
}
