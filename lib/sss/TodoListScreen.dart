import 'dart:io';

import 'package:appworkproject/sss/AddEditTodoScreen.dart';
import 'package:appworkproject/sss/TodoController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoListScreen extends StatelessWidget {
  final TodoController todoController = Get.find(); // Access the TodoController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => todoController.searchQuery.value = query,
              decoration: InputDecoration(
                labelText: 'Search Todos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: todoController.filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = todoController.filteredTodos[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(todo['title']),
                      subtitle: Text(todo['description']),
                      leading: todo['image'] != null
                          ? Image.file(
                              File(todo['image']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                Get.to(() => AddEditTodoScreen(index: index)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => todoController.deleteTodo(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() =>
            AddEditTodoScreen()), // Open screen without an index for new todo
        child: Icon(Icons.add),
      ),
    );
  }
}
