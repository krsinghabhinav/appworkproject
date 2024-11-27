import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Addtaskcontroller extends GetxController {
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final titelFocus = FocusNode().obs;
  final descriptionFocus = FocusNode().obs;
}
