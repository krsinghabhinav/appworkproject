import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appworkproject/todoappsharepreferance/todocontrollertodo.dart';
import 'showlsittodoscreen.dart';

class Addandupdatescreen extends StatelessWidget {
  final int? index;
  Addandupdatescreen({this.index});

  final todoController = Get.put(Todocontrollertodo());

  @override
  Widget build(BuildContext context) {
    if (index != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final todo = todoController.todolistvalue[index!];
        todoController.titleContol.text = todo['title'];
        todoController.descControl.text = todo['desc'];
        todoController.imgespath.value = todo['image'];
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        todoController.titleContol.clear();
        todoController.descControl.clear();
        todoController.imgespath.value = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(index != null ? 'Edit Todo' : 'Add Todo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextField(
                controller: todoController.titleContol,
                decoration: InputDecoration(
                  labelText: 'Enter title',
                ),
              ),
              TextField(
                controller: todoController.descControl,
                decoration: InputDecoration(
                  labelText: 'Enter description',
                ),
              ),
              Obx(() {
                return todoController.imgespath.value != null
                    ? Image.file(
                        File(todoController.imgespath.value!),
                        width: 400,
                        height: 400,
                      )
                    : SizedBox();
              }),
              TextButton.icon(
                onPressed: () => todoController.pickimage(),
                icon: Icon(Icons.image),
                label: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Check if title, description, and image path are not empty or null
                  if (todoController.titleContol.text.isNotEmpty &&
                      todoController.descControl.text.isNotEmpty &&
                      todoController.imgespath.value != null) {
                    todoController.savetodo(index: index);
                    Get.to(Showlsittodoscreen());
                    // Navigate back instead of Get.to() to return to the previous screen
                  } else {
                    // Optionally, you can show an error message or feedback if any field is empty
                    Get.snackbar('Error', 'Please fill all fields',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }, // Add a condition to check if the fields are not empty
                child: index != null ? Text('Update') : Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
