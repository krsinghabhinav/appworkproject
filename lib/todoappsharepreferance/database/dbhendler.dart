import 'dart:io';

import 'package:appworkproject/todoappsharepreferance/model/todomodel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;

//create a database helper object
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
// getApplicationDocumentsDirectory:== Ye method device ke application-specific documents directory ka path provide karta hai.
// Is directory ko generally user-specific data store karne ke liye use kiya jata hai jo
// app ke lifecycle ke dauran persist rehna chahiye.
// Files save karna (e.g., text files, JSON files, images).
// App ka important data store karna jo user ke liye visible ya accessible ho sakta hai.

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'todo.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the database, create the table
      await db.execute('''
            CREATE TABLE todoTable(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            checkbox INTEGER
)
''');
    });
    return _database;
  }

  //insert data in the table
  inserData(Todomodel todomodel) async {
    Database? db = await database;
    final value = todomodel.toMap();
    db!.insert('todoTable', value);
  }

  Future<List<Todomodel>> readData() async {
    Database? db = await database;
    List<Map<String, Object?>> list = await db!.query('todoTable');
    //    print(lsit);
    return list.map((map) => Todomodel.fromMap(map)).toList();
  }

  delete(Todomodel todo) async {
    Database? db =
        await database; // Assuming `database` is your database connection
    int result = await db!.delete(
      'todoTable',
      where: 'id = ?',
      whereArgs: [todo.id], // Pass the value as a list
    );
    return result; // Optionally return the result (number of rows affected)
  }

  update(Todomodel todo) async {
    Database? db = await database;

    // The data to update
    Map<String, dynamic> values = {
      'title': todo.title,
      'description': todo.description,
    };

    // Perform the update
    int result = await db!.update(
      'todoTable', // Table name
      values, // The updated values
      where: 'id = ?', // Condition (update where the id matches)
      whereArgs: [todo.id], // The argument for the id
    );

    return result; // Returns the number of rows affected
  }
}
