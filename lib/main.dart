import 'package:appworkproject/customerdetails/auth/Register.dart';
import 'package:appworkproject/customerdetails/splash_screen.dart';
import 'package:appworkproject/sss/TodoController.dart';
import 'package:appworkproject/sss/TodoListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'customerdetails/controller/customer_controller.dart';
import 'regg/profile_registration.dart';
import 'sharepref/register_page.dart';
import 'sqflitetest/DatabaseController.dart';
import 'sqflitetest/ShowDataScreen.dart';
import 'sqflitetest/sqflitetest.dart';
import 'sss/toosoo.dart';
import 'todoappsharepreferance/showlsittodoscreen.dart';

void main() {
  Get.put(CustomerController());
  Get.put(TodoController());
  Get.put(DatabaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splaceScreen(),
    );
  }
}
