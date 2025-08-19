import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task task)? onEdit;
  final void Function(Task task)? onDelete;
  final void Function(Task task)? onToggleComplete;

  const TaskListWidget({
    Key? key,
    required this.tasks,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No hay tareas disponibles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                task.title.isNotEmpty ? task.title[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  task.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onToggleComplete != null)
                  IconButton(
                    icon: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                    onPressed: () => onToggleComplete!(task),
                  ),
                if (onEdit != null)
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => onEdit!(task),
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDelete!(task),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
