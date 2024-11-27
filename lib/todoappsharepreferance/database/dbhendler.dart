import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;

  Future<Database?> get database async {
// getApplicationDocumentsDirectory:== Ye method device ke application-specific documents directory ka path provide karta hai.
// Is directory ko generally user-specific data store karne ke liye use kiya jata hai jo
// app ke lifecycle ke dauran persist rehna chahiye.
// Files save karna (e.g., text files, JSON files, images).
// App ka important data store karna jo user ke liye visible ya accessible ho sakta hai.

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'todo.db');
    _database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) {});
  }
}
