import 'package:appworkproject/todoappsharepreferance/database/dbhendler.dart';
import 'package:appworkproject/todoappsharepreferance/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Addtaskcontroller extends GetxController {
  final DBHelper db = DBHelper();
  // Reactive List to store tasks
  final tasks = <Todomodel>[].obs;
  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  // Focus Nodes
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode searchFocus = FocusNode();

  // Fetch Data from Database
  Future<List<Todomodel>> fetchData() async {
    try {
      final data = await db.readData();
      return data; // Ensure readData returns List<Map<String, dynamic>>
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch data: $e",
          snackPosition: SnackPosition.BOTTOM);
      return [];
    }
  }

  Future<void> updateTask(Todomodel updatedTask) async {
    try {
      // Call DBHelper's update method
      await db.update(updatedTask);
      // Reload tasks after update
      tasks.value = await db.readData();
      Get.snackbar("Success", "Task updated successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes when the controller is destroyed
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    searchFocus.dispose();
    super.onClose();
  }
}
