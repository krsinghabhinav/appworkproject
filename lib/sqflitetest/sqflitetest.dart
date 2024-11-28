// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class ShowDataScreen extends StatefulWidget {
//   @override
//   _ShowDataScreenState createState() => _ShowDataScreenState();
// }

// class _ShowDataScreenState extends State<ShowDataScreen> {
//   List<Map<String, dynamic>> _items = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadItems();
//   }

//   Future<void> _loadItems() async {
//     final database = await _initDB();
//     final List<Map<String, dynamic>> items = await database.query('items');
//     setState(() {
//       _items = items;
//     });
//   }

//   Future<void> _deleteItem(int id) async {
//     final database = await _initDB();
//     await database.delete('items', where: 'id = ?', whereArgs: [id]);
//     _loadItems(); // Reload items after deleting
//   }

//   Future<Database> _initDB() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = join(directory.path, 'items.db');
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE items (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             title TEXT,
//             description TEXT,
//             image TEXT
//           )
//         ''');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Saved Items')),
//       body: _items.isEmpty
//           ? Center(child: Text('No items found.'))
//           : ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (context, index) {
//                 final item = _items[index];
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     leading: item['image'] != null
//                         ? Image.file(File(item['image']), width: 50, height: 50)
//                         : Icon(Icons.image),
//                     title: Text(item['title']),
//                     subtitle: Text(item['description']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AddEditScreen(
//                                   itemId: item['id'],
//                                   title: item['title'],
//                                   description: item['description'],
//                                   imagePath: item['image'],
//                                 ),
//                               ),
//                             ).then((_) => _loadItems());
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => _deleteItem(item['id']),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddEditScreen()),
//           ).then((_) => _loadItems());
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class AddEditScreen extends StatefulWidget {
//   final int? itemId;
//   final String? title;
//   final String? description;
//   final String? imagePath;

//   AddEditScreen({this.itemId, this.title, this.description, this.imagePath});

//   @override
//   _AddEditScreenState createState() => _AddEditScreenState();
// }

// class _AddEditScreenState extends State<AddEditScreen> {
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.title != null) _titleController.text = widget.title!;
//     if (widget.description != null)
//       _descriptionController.text = widget.description!;
//     if (widget.imagePath != null) _imageFile = File(widget.imagePath!);
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _saveData() async {
//     if (_titleController.text.isNotEmpty &&
//         _descriptionController.text.isNotEmpty &&
//         _imageFile != null) {
//       final title = _titleController.text;
//       final description = _descriptionController.text;
//       final imagePath = _imageFile!.path;

//       final database = await _initDB();

//       if (widget.itemId == null) {
//         // Add new item
//         await database.insert(
//           'items',
//           {'title': title, 'description': description, 'image': imagePath},
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//       } else {
//         // Update existing item
//         await database.update(
//           'items',
//           {'title': title, 'description': description, 'image': imagePath},
//           where: 'id = ?',
//           whereArgs: [widget.itemId],
//         );
//       }

//       Navigator.pop(context as BuildContext);
//     }
//   }

//   Future<Database> _initDB() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = join(directory.path, 'items.db');
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute('''
//           CREATE TABLE items (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             title TEXT,
//             description TEXT,
//             image TEXT
//           )
//         ''');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: Text(widget.itemId == null ? 'Add Item' : 'Edit Item')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
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
//             SizedBox(height: 20),
//             _imageFile == null
//                 ? Text('No image selected')
//                 : Image.file(_imageFile!, height: 100, width: 100),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Pick Image'),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 _saveData();
//                 Get.to(ShowDataScreen());
//               },
//               child: Text(widget.itemId == null ? 'Save Data' : 'Update Data'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
