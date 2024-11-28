import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/loginscreen.dart';
import 'invoice_page.dart';

class splaceScreen extends StatefulWidget {
  @override
  _splaceScreenState createState() => _splaceScreenState();
}

class _splaceScreenState extends State<splaceScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 3)); // Simulate a loading delay

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InvoicePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.height / 2.4,
            child: Image.asset(
              "assets/animation/appwsplash.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: Get.height / 20,
          ),
          Center(
            child: CupertinoActivityIndicator(
              radius: 35,
            ),
          ),
        ],
      ),
    );
  }
}
