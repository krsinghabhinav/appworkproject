import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/addtaskcontroller.dart';
import '../model/todomodel.dart';
import 'addtask.dart';
import '../constent/colors.dart';
import 'todoitems.dart';

class Todomainscreen extends StatefulWidget {
  const Todomainscreen({Key? key}) : super(key: key);

  @override
  State<Todomainscreen> createState() => _TodomainscreenState();
}

class _TodomainscreenState extends State<Todomainscreen> {
  final addcontroller = Get.put(Addtaskcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.menu,
          color: tdyellow,
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/image/avatar.png"),
            radius: 25,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section with Gradient and Search Bar
          Stack(
            children: [
              Container(
                height: Get.height / 3.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, tdyellow.withAlpha(200)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: tdyellow, blurRadius: 5, spreadRadius: 2),
                  ],
                ),
              ),
              Column(
                children: [
                  searchBar(),
                  const SizedBox(height: 10),
                  Text(
                    "Your Task",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Task List Section
          Expanded(
            child: FutureBuilder<List<Todomodel>>(
              future: addcontroller.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No tasks available"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final task = snapshot.data![index];
                    return todotask(task: task);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => Addtask());
        },
        child: const Icon(
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

  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: textColor,
              blurRadius: 1,
              offset: const Offset(1, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextFormField(
          focusNode: addcontroller.searchFocus,
          controller: addcontroller.searchController,
          onChanged: (value) {
            // Handle search logic
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(top: 12),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            hintText: "Search Task",
          ),
        ),
      ),
    );
  }
}
