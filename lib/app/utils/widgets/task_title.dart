import 'package:flutter/material.dart';
import 'package:tasks/app/model/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        title: Text(
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          0.0,
        ),
        children: [
          ListTile(title: Text(task.description)),
        ],
      ),
    );
  }
}
