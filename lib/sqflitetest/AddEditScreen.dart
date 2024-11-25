import 'package:appworkproject/sqflitetest/ShowDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'DatabaseController.dart';

class AddEditScreen extends StatelessWidget {
  final int? itemId;
  final DatabaseController controller = Get.find<DatabaseController>();

  AddEditScreen({this.itemId}) {
    // Initialize data in the controller for both edit and add scenarios
    controller.initData(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemId == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            Obx(() {
              return controller.imageFile.value == null
                  ? Text('No image selected')
                  : Image.file(controller.imageFile.value!,
                      height: 150, width: 150);
            }),
            ElevatedButton(
              onPressed: controller.pickImage,
              child: Text('Pick Image'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                controller.saveData(itemId);
                Get.to(ShowDataScreen()); // Return to the previous screen
              },
              child: Text(itemId == null ? 'Save Data' : 'Update Data'),
            ),
          ],
        ),
      ),
    );
  }
}
