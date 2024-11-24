import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_screen.dart';

class reg extends StatefulWidget {
  final Map<String, dynamic>? user; // The user to edit (if any)
  final int? index; // The index of the user being edited (if any)

  reg({this.user, this.index});

  @override
  _regState createState() => _regState();
}

class _regState extends State<reg> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _users = [];
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      // Preload user data for editing
      usernameController.text = widget.user!['username'];
      emailController.text = widget.user!['email'];
      phoneController.text = widget.user!['phone'];
      passwordController.text = widget.user!['password'];
      confirmPasswordController.text = widget.user!['password'];
      dobController.text = widget.user!['dob'];
      _profileImage = widget.user!['profileImage'] != null
          ? File(widget.user!['profileImage'])
          : null;
    }
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersData = prefs.getString('users');
    if (usersData != null) {
      setState(() {
        _users = List<Map<String, dynamic>>.from(json.decode(usersData));
      });
    }
  }

  Future<void> _saveUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('users', json.encode(_users));
  }

  void _addOrUpdateUser() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }
    final user = {
      'username': usernameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'dob': dobController.text,
      'profileImage': _profileImage?.path,
    };

    if (editingIndex == null) {
      setState(() {
        _users.add(user); // Add new user
      });
    } else {
      setState(() {
        _users[editingIndex!] = user; // Update existing user
      });
    }

    _saveUsers();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User saved successfully')),
    );
    _clearFields(); // Clear fields after saving
  }

  void _clearFields() {
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    dobController.clear();
    setState(() {
      _profileImage = null;
      editingIndex = null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editingIndex == null ? 'Register Page' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _profileImage != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_profileImage!),
                          radius: 40,
                        )
                      : CircleAvatar(
                          child: Icon(Icons.person, size: 40),
                          radius: 40,
                        ),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Pick Profile Image'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateUser,
                child: Text(editingIndex == null ? 'Save' : 'Update'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(users: _users),
                    ),
                  );
                },
                child: Text('Show List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
