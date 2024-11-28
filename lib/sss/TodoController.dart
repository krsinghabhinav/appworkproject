import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class TodoController extends GetxController {
  var todos = <Map<String, dynamic>>[].obs; //
  var searchQuery = ''.obs; // Observable search query
  var imagePath = Rx<String?>(null); // Observable image path

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Save todos to SharedPreferences
  Future<void> saveTodos() async {
    // SharedPreferences ka instance le rahe hain
    final prefs = await SharedPreferences.getInstance();

    // 'todos' list ko JSON format mein convert kar rahe hain aur SharedPreferences mein store kar rahe hain
    await prefs.setString('todos', jsonEncode(todos));
  }

  // Load todos from SharedPreferences

  Future<void> loadTodos() async {
    // SharedPreferences se instance le rahe hain
    final prefs = await SharedPreferences.getInstance();

    // 'todos' key se saved string ko load kar rahe hain
    final todosString = prefs.getString('todos');

    // Agar 'todosString' null nahi hai, toh decode karenge aur todos list ko update karenge
    if (todosString != null) {
      todos.value = List<Map<String, dynamic>>.from(jsonDecode(todosString));
    }
  }

  // Pick an image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  void saveTodo({int? index}) {
    // Step 1: Check if title and description are not empty
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      // Step 2: Create a new todo item with title, description, and image
      final newTodo = {
        'title': titleController.text, // Title from titleController
        'description': descriptionController
            .text, // Description from descriptionController
        'image': imagePath.value, // Image path from imagePath observable
      };

      // Step 3: If index is not null, update the existing todo at that index
      // Else, add the new todo to the list
      if (index != null) {
        todos[index] = newTodo; // Update todo at the specified index
      } else {
        todos.add(newTodo); // Add the new todo to the list
      }

      // Step 4: Save the updated list of todos to SharedPreferences
      saveTodos(); // Save todos to SharedPreferences
    }
  }

  // Delete a todo
  void deleteTodo(int index) {
    todos.removeAt(index);
    saveTodos();
  }

  // Filter todos based on search query
  List<Map<String, dynamic>> get filteredTodos {
    final query = searchQuery.value.toLowerCase();
    return todos.where((todo) {
      return todo['title'].toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    searchQuery.listen(
        (_) => update()); // Update filteredTodos when searchQuery changes
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
