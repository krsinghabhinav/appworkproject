import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appworkproject/sss/TodoController.dart';
import 'package:appworkproject/sss/TodoListScreen.dart';

class AddEditTodoScreen extends StatelessWidget {
  final int? index;
  final TodoController todoController = Get.find(); // Access the TodoController

  AddEditTodoScreen({this.index});

  @override
  Widget build(BuildContext context) {
    // Use post-frame callback to update the controller after build is complete
    if (index != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final todo = todoController.todos[index!];
        todoController.titleController.text = todo['title'];
        todoController.descriptionController.text = todo['description'];
        todoController.imagePath.value = todo['image'];
      });
    } else {
      // Reset the controllers if it's a new todo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        todoController.titleController.clear();
        todoController.descriptionController.clear();
        todoController.imagePath.value = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(index != null ? 'Edit Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: todoController.titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: todoController.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            Obx(() {
              return todoController.imagePath.value != null
                  ? Image.file(
                      File(todoController.imagePath.value!),
                      height: 100,
                    )
                  : SizedBox();
            }),
            TextButton.icon(
              onPressed: () => todoController.pickImage(),
              icon: Icon(Icons.image),
              label: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                todoController.saveTodo(
                    index: index); // Pass the index if editing
                Get.to(TodoListScreen()); // Go back after saving
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
