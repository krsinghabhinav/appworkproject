import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TodoController extends GetxController {
  var todos = <Map<String, dynamic>>[].obs; // List of todos
  var filteredTodos =
      <Map<String, dynamic>>[].obs; // Filtered todos based on search query
  var searchQuery = ''.obs; // Observable search query
  var imagePath = Rx<String?>(null); // Observable image path

  final titleController = TextEditingController(); // Title controller
  final descriptionController =
      TextEditingController(); // Description controller

  // Load todos from SharedPreferences
  Future<void> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      todos
          .assignAll(List<Map<String, dynamic>>.from(json.decode(todosString)));
      filteredTodos.assignAll(todos); // Initialize filteredTodos
    }
  }

  // Save todos to SharedPreferences
  Future<void> saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', json.encode(todos));
  }

  // Filter todos based on search query
  void filterTodos() {
    final query = searchQuery.value.toLowerCase();
    filteredTodos.assignAll(todos.where((todo) {
      return todo['title'].toLowerCase().contains(query) ||
          todo['description'].toLowerCase().contains(query);
    }).toList());
  }

  // Add or update a todo
  void saveTodo({int? index}) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      final newTodo = {
        'title': titleController.text,
        'description': descriptionController.text,
        'image': imagePath.value,
      };

      if (index != null) {
        // Update the existing todo at the given index
        todos[index] = newTodo;
        filteredTodos[index] =
            newTodo; // Make sure the filteredTodos list is updated too
      } else {
        // Add a new todo if no index is provided
        todos.add(newTodo);
        filteredTodos.add(newTodo);
      }
      saveTodos();
    }
  }

  // Pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
    }
  }

  // Delete a todo
  void deleteTodo(int index) {
    todos.removeAt(index);
    filteredTodos.removeAt(index);
    saveTodos();
  }

  @override
  void onInit() {
    super.onInit();
    loadTodos(); // Load todos when controller is initialized
    searchQuery
        .listen((query) => filterTodos()); // Listen for changes in search query
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    descriptionController.dispose();
  }
}
