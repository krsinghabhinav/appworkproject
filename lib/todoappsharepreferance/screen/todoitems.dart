import 'package:appworkproject/todoappsharepreferance/constent/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/addtaskcontroller.dart';
import '../model/todomodel.dart';

class TodoTask extends StatefulWidget {
  final Todomodel task;

  const TodoTask({
    super.key,
    required this.task,
  });

  @override
  State<TodoTask> createState() => _TodoTaskState();
}

class _TodoTaskState extends State<TodoTask> {
  final Addtaskcontroller addcontroller = Get.put(Addtaskcontroller());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: textColor
                .withOpacity(0.5), // Slight transparency for better appearance
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        color: tdyellow,
      ),
      child: ListTile(
        onTap: () {
          if (widget.task.checkbox == 0) {
            widget.task.checkbox = 1;
          } else {
            widget.task.checkbox = 0;
          }
          setState(() {});
        },
        leading: widget.task.checkbox == 0
            ? Icon(Icons.check_box_outline_blank)
            : Icon(Icons.check_box),
        title: Text(
          widget.task.title ?? "Unnamed Task",
          style: TextStyle(
            decoration: widget.task.checkbox == 1
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: widget.task.checkbox == 1 ? Colors.grey : textColor,
          ),
        ),
        subtitle: Text(
          widget.task.description ?? "No Description",
          style: TextStyle(color: textColor.withOpacity(0.7)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Add action for edit button
                },
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  // Add action for delete button
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
