import 'package:appworkproject/customerdetails/auth/Register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../invoice_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String phone = phoneController.text;
    String password = passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter both phone number and password');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPhone = prefs.getString('phone');
    String? storedPassword = prefs.getString('password');

    if (phone == storedPhone && password == storedPassword) {
      prefs.setBool('isLoggedIn', true); // Mark the user as logged in
      Fluttertoast.showToast(msg: 'Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InvoicePage()),
      );
    } else {
      Fluttertoast.showToast(msg: 'Invalid phone number or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Get.height / 2.2,
                child: Lottie.asset("assets/animation/auth2.json"),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: Get.height / 40,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Padding
                  shape: RoundedRectangleBorder(
                    // Rounded corners
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Not registered? Create an account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
