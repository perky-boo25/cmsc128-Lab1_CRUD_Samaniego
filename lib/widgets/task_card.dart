import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleDone;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleDone,
    this.onDelete,
  });

  String _formattedDueDateTime(DateTime dt) =>
      DateFormat('MMM d, yyyy h:mm a').format(dt);

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return Colors.pinkAccent;
      case Priority.medium:
        return Colors.orangeAccent;
      case Priority.low:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => onToggleDone?.call(),
        ),
        title: Text(
          task.title,
          style: task.isDone
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          '${task.tag.name} ★ ${_formattedDueDateTime(task.dueDateTime)}',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: _priorityColor(task.priority),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
