import 'package:flutter/material.dart';

import '../model/todomodel.dart';

class todotask extends StatelessWidget {
  const todotask({
    super.key,
    required this.task,
  });

  final Todomodel task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(task.title ?? "Unnamed Task"),
        subtitle: Text(task.description ?? "No Description"),
      ),
    );
  }
}
