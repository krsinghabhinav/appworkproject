import 'dart:io';

import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  DetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user['profileImage'] != null
                ? CircleAvatar(
                    backgroundImage: FileImage(File(user['profileImage'])),
                    radius: 60,
                  )
                : CircleAvatar(
                    child: Icon(Icons.person, size: 60),
                    radius: 60,
                  ),
            SizedBox(height: 20),
            Text('Username: ${user['username']}',
                style: TextStyle(fontSize: 18)),
            Text('Email: ${user['email']}', style: TextStyle(fontSize: 18)),
            Text('Phone: ${user['phone']}', style: TextStyle(fontSize: 18)),
            Text('Date of Birth: ${user['dob']}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
