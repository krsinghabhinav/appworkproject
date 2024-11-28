import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseController extends GetxController {
  // Observables for items and filtered items
  var items = [].obs; // Observable list of all items
  var filteredItems = [].obs; // Observable list for searched or filtered items

  // Controllers for text inputs
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Image picker and file
  var imageFile = Rx<File?>(null);
  final picker = ImagePicker();

  // Initialize the database
  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'items.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            image TEXT
          )
        ''');
      },
    );
  }

  // Load all items
  Future<void> loadItems() async {
    final db = await _initDB();
    final data = await db.query('items');
    items.value = data; // Update items list
    filteredItems.value = data; // Show all items initially
  }

  // Save or update item
  Future<void> saveData(int? id) async {
    final db = await _initDB();
    final data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'image': imageFile.value?.path,
    };

    if (id == null) {
      await db.insert('items', data); // Add new item
    } else {
      await db.update('items', data,
          where: 'id = ?', whereArgs: [id]); // Update existing
    }

    await loadItems();
    clearInputs(); // Reset inputs
  }

  // Delete an item
  Future<void> deleteItem(int id) async {
    final db = await _initDB();
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
    await loadItems();
  }

  // Search items
  void searchItems(String query) {
    if (query.isEmpty) {
      filteredItems.value = items; // Show all items if query is empty
    } else {
      filteredItems.value = items.where((item) {
        final title = item['title'].toString().toLowerCase();
        final desc = item['description'].toString().toLowerCase();
        return title.contains(query.toLowerCase()) ||
            desc.contains(query.toLowerCase());
      }).toList();
    }
  }

  // Pick an image
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  // Initialize data for add/edit
  void initData(int? id) {
    if (id == null) {
      clearInputs(); // Clear inputs for new item
    } else {
      final item = items.firstWhere((e) => e['id'] == id);
      titleController.text = item['title'];
      descriptionController.text = item['description'];
      imageFile.value = item['image'] != null ? File(item['image']) : null;
    }
  }

  // Clear all input fields
  void clearInputs() {
    titleController.clear();
    descriptionController.clear();
    imageFile.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    loadItems(); // Load all items when initialized
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
