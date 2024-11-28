import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todocontrollertodo extends GetxController {
  final todolistvalue = <Map<String, dynamic>>[].obs;
  final searchList = ''.obs;
  final imgespath = Rx<String?>(null);
  final titleContol = TextEditingController();
  final descControl = TextEditingController();

  Future<void> addtodolsitvalue() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("todolistvalue", jsonEncode(todolistvalue));
  }

  Future<void> loadtodolistvalue() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString("todolistvalue");
    if (data != null) {
      todolistvalue.value = List<Map<String, dynamic>>.from(jsonDecode(data));
    }
  }

  Future<void> pickimage() async {
    final picker = ImagePicker();
    final pickimagepath = await picker.pickImage(source: ImageSource.gallery);
    if (pickimagepath != null) {
      imgespath.value = pickimagepath.path;
    }
  }

  void savetodo({int? index}) {
    if (titleContol.text.isNotEmpty &&
        descControl.text.isNotEmpty &&
        imgespath.value != null) {
      final newtodoadd = {
        "title": titleContol.text,
        "desc": descControl.text,
        "image": imgespath.value,
      };
      if (index != null) {
        todolistvalue[index] = newtodoadd; // for update
      } else {
        todolistvalue.add(newtodoadd);
      }
      addtodolsitvalue(); // Save updated list to SharedPreferences
    }
  }

  void deletetodo(int index) {
    todolistvalue.removeAt(index); // Corrected removal by index
    addtodolsitvalue(); // Save updated list to SharedPreferences
  }

  List<Map<String, dynamic>> get searchtodo {
    final query = searchList.value.toLowerCase();
    return todolistvalue.where((search) {
      return search["title"].toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadtodolistvalue(); // Ensure the list is loaded at the start
    searchList.listen((_) {
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();
    titleContol.dispose();
    descControl.dispose();
  }
}
