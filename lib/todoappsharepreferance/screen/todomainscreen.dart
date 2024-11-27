import 'package:appworkproject/todoappsharepreferance/constent/colors.dart';
import 'package:appworkproject/todoappsharepreferance/screen/addtask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Todomainscreen extends StatefulWidget {
  const Todomainscreen({super.key});

  @override
  State<Todomainscreen> createState() => _TodomainscreenState();
}

class _TodomainscreenState extends State<Todomainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Addtask());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }
}
