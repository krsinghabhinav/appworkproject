import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'DatabaseController.dart';
import 'AddEditScreen.dart';

class ShowDataScreen extends StatelessWidget {
  final DatabaseController controller = Get.put(DatabaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Saved Items'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.searchItems,
              decoration: InputDecoration(
                hintText: 'Search items...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.filteredItems.isEmpty) {
          return Center(child: Text('No items found.'));
        }
        return ListView.builder(
          itemCount: controller.filteredItems.length,
          itemBuilder: (context, index) {
            final item = controller.filteredItems[index];
            return Card(
              child: ListTile(
                leading: item['image'] != null
                    ? Image.file(File(item['image']), width: 50, height: 50)
                    : Icon(Icons.image),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Get.to(AddEditScreen(itemId: item['id'])),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteItem(item['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddEditScreen()),
        child: Icon(Icons.add),
      ),
    );
  }
}
