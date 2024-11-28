// import 'package:flutter/material.dart';
// import 'dart:convert'; // For JSON encoding/decoding
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image_picker/image_picker.dart'; // For image picking
// import 'dart:io'; // For File management

// class TodoListScreen extends StatefulWidget {
//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   List<Map<String, dynamic>> todos = [];
//   List<Map<String, dynamic>> filteredTodos = [];
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadTodos();
//     _searchController.addListener(_filterTodos);
//   }

//   Future<void> _loadTodos() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? todosString = prefs.getString('todos');
//     if (todosString != null) {
//       setState(() {
//         todos = List<Map<String, dynamic>>.from(json.decode(todosString));
//         filteredTodos = List.from(todos); // Initialize filteredTodos
//       });
//     }
//   }

//   Future<void> _saveTodos() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('todos', json.encode(todos));
//   }

//   void _deleteTodo(int index) {
//     setState(() {
//       todos.removeAt(index);
//       filteredTodos.removeAt(index); // Remove from filtered list as well
//     });
//     _saveTodos();
//   }

//   void _navigateToAddEditScreen({int? index}) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditTodoScreen(
//           todo: index != null ? todos[index] : null,
//         ),
//       ),
//     );
//     if (result != null) {
//       setState(() {
//         if (index != null) {
//           todos[index] = result;
//         } else {
//           todos.add(result);
//         }
//         filteredTodos = List.from(todos); // Update filteredTodos
//       });
//       _saveTodos();
//     }
//   }

//   // Function to filter todos based on the search query
//   void _filterTodos() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredTodos = todos.where((todo) {
//         return todo['title'].toLowerCase().contains(query) ||
//             todo['description'].toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_filterTodos);
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todo List'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Todos',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredTodos.length,
//               itemBuilder: (context, index) {
//                 final todo = filteredTodos[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: ListTile(
//                     title: Text(todo['title']),
//                     subtitle: Text(todo['description']),
//                     leading: todo['image'] != null
//                         ? Image.file(
//                             File(todo['image']),
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.blue),
//                           onPressed: () =>
//                               _navigateToAddEditScreen(index: index),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deleteTodo(index),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _navigateToAddEditScreen(),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddEditTodoScreen extends StatefulWidget {
//   final Map<String, dynamic>? todo;

//   AddEditTodoScreen({this.todo});

//   @override
//   _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
// }

// class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.todo != null) {
//       _titleController.text = widget.todo!['title'] ?? '';
//       _descriptionController.text = widget.todo!['description'] ?? '';
//       _imagePath = widget.todo!['image'];
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imagePath = pickedFile.path;
//       });
//     }
//   }

//   void _saveTodo() {
//     if (_titleController.text.isNotEmpty &&
//         _descriptionController.text.isNotEmpty) {
//       Navigator.pop(context, {
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'image': _imagePath,
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.todo != null ? 'Edit Todo' : 'Add Todo'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             SizedBox(height: 10),
//             _imagePath != null
//                 ? Image.file(
//                     File(_imagePath!),
//                     height: 100,
//                   )
//                 : SizedBox(),
//             TextButton.icon(
//               onPressed: _pickImage,
//               icon: Icon(Icons.image),
//               label: Text('Pick Image'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveTodo,
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
