import 'dart:io';
import 'package:flutter/material.dart';
import 'register_page.dart'; // Import RegisterPage
import 'details_screen.dart'; // Import DetailsScreen

class ListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> users;

  ListScreen({required this.users});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _users = widget.users;
  }

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  void _editUser(int index) async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reg(
          user: _users[index], // Pass the user to be edited
          index: index,
        ),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        _users[index] = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            child: ListTile(
              leading: user['profileImage'] != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(user['profileImage'])),
                    )
                  : CircleAvatar(
                      child: Icon(Icons.person),
                    ),
              title: Text(user['username']),
              subtitle: Text(user['email']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(user: user),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editUser(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newUser = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => reg(),
            ),
          );

          if (newUser != null) {
            setState(() {
              _users.add(newUser);
            });
          }
        },
      ),
    );
  }
}
