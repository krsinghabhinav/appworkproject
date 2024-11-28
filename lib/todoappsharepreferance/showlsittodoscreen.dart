import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appworkproject/todoappsharepreferance/todocontrollertodo.dart';
import 'addandupdatescreen.dart';

class Showlsittodoscreen extends StatefulWidget {
  const Showlsittodoscreen({super.key});

  @override
  State<Showlsittodoscreen> createState() => _ShowlsittodoscreenState();
}

class _ShowlsittodoscreenState extends State<Showlsittodoscreen> {
  final todoController = Get.put(Todocontrollertodo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Show Todo List"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              child: TextFormField(
                onChanged: (value) {
                  todoController.searchList.value = value;
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: todoController.searchtodo.length,
                  itemBuilder: (context, index) {
                    final data = todoController.searchtodo[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: data['image'] != null
                            ? Image.file(
                                File(data['image']),
                                height: 80,
                              )
                            : null,
                        title: Text(data['title']),
                        subtitle: Text(data['desc']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Get.to(Addandupdatescreen(index: index));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                todoController.deletetodo(
                                    index); // Pass the unique identifier, e.g., title or any unique field
                              },
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
              Addandupdatescreen()); // Open screen without an index for new todo
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
