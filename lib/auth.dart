import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'customerdetails/invoice_page.dart';

// Splash Screen
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

// Login Page
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

// Register Page
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> register() async {
    String phone = phoneController.text;
    String password = passwordController.text;
    String name = nameController.text;

    if (phone.isEmpty || password.isEmpty || name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
    prefs.setString('password', password);
    prefs.setString('name', name);
    prefs.setBool('isLoggedIn', false); // Default logged out status

    Fluttertoast.showToast(msg: 'Registration successful');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Register',
          style: TextStyle(
              fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: Get.height / 2.3,
                child: Lottie.asset("assets/animation/auth1.json"),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: Get.height / 70,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: Get.height / 70,
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
                onPressed: register,
                child: Text(
                  'Register',
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
            ],
          ),
        ),
      ),
    );
  }
}

// Test2 Page
// class Test2Page extends StatelessWidget {
//   Future<void> logout(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isLoggedIn', false); // Mark user as logged out

//     Fluttertoast.showToast(msg: 'Logged out successfully');
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               logout(context);
//             },
//           ),
//         ],
//       ),
//       body: Center(child: Text('Welcome to Test2 Page!')),
//     );
//   }
// }
