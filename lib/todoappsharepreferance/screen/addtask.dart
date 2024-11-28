import 'package:appworkproject/todoappsharepreferance/constent/colors.dart';
import 'package:appworkproject/todoappsharepreferance/database/dbhendler.dart';
import 'package:appworkproject/todoappsharepreferance/model/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/addtaskcontroller.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final addcontroller = Get.put(Addtaskcontroller());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          addcontroller.titleFocus.unfocus();
          addcontroller.descriptionFocus.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height / 2.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [tdyellow, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(170),
                    bottomRight: Radius.circular(170),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Add Task",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: tdyellow.withOpacity(0.5),
                                spreadRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(23)),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          focusNode: addcontroller.titleFocus,
                          textInputAction: TextInputAction.next,
                          controller: addcontroller.titleController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            prefixIcon: Icon(
                              Icons.title,
                              size: 30,
                              color: Colors.amber,
                            ),
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                color: tdyellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter title';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: tdyellow.withOpacity(0.5),
                                spreadRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(23)),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          focusNode: addcontroller.descriptionFocus,
                          textInputAction: TextInputAction.next,
                          controller: addcontroller.descriptionController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.all(12),
                            prefixIcon: Icon(
                              Icons.description,
                              size: 30,
                              color: Colors.amber,
                            ),
                            hintText: 'Description',
                            hintStyle: TextStyle(
                                height: 3,
                                color: tdyellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String description = addcontroller
                                  .descriptionController.value.text;
                              String name =
                                  addcontroller.titleController.value.text;
                            }
                            await DBHelper()
                                .inserData(Todomodel(
                              title: addcontroller.titleController.value.text,
                              description: addcontroller
                                  .descriptionController.value.text,
                            ))
                                .then((value) {
                              print("Data is inserted ");
                            });

                            var data = await DBHelper().readData();

                            print(data.map((element) => print(
                                  element.toMap(),
                                )));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: tdyellow,
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
