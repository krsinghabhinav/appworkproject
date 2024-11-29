import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'customerdetails/controller/customer_controller.dart';
import 'imagesqflite/homepage.dart';
import 'sqflitetest/DatabaseController.dart';
import 'sss/TodoController.dart';

void main() {
  // Initialize controllers with Get
  Get.put(CustomerController());
  Get.put(TodoController());
  Get.put(DatabaseController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Define a custom MaterialColor for primarySwatch
  final MaterialColor myCustomColor = MaterialColor(
    0xffFFBB5C, // Base color
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE7B2),
      200: Color(0xFFFFD480),
      300: Color(0xFFFFC04F),
      400: Color(0xFFFFAC1E),
      500: Color(0xffFFBB5C), // Primary color
      600: Color(0xFFFFA24D),
      700: Color(0xFFFF8F3B),
      800: Color(0xFFFF7B2A),
      900: Color(0xFFFF6718),
    },
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'MondayRain',
        primarySwatch: myCustomColor,
        primaryColor: myCustomColor.shade500,
        scaffoldBackgroundColor: myCustomColor
            .shade50, // Example: Use a light shade for scaffold background
        colorScheme: ColorScheme.fromSwatch(primarySwatch: myCustomColor),
        appBarTheme: AppBarTheme(
          backgroundColor: myCustomColor.shade500, // AppBar background color
          foregroundColor: Colors.white, // Text/icon color in AppBar
          elevation: 4, // AppBar shadow
          centerTitle: true, // Center the title
          titleTextStyle: TextStyle(
            fontFamily: 'MondayRain', // Use the custom font for AppBar title
            fontSize: 20, // Title font size
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // AppBar icon color
            size: 24, // Icon size
          ),
        ),
      ),
      home: HomePage(), // Ensure the correct widget name is used
    );
  }
}
