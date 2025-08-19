import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import '../widgets/task_list_widget.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  final String? filter;
  final int? categoryId;

  const TaskListScreen({Key? key, this.filter, this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(filter != null
            ? "Tareas $filter"
            : categoryId != null
                ? "Categoría: $categoryId"
                : "Todas las tareas"),
      ),
      body: FutureBuilder(
        future: taskProvider.loadTasks(filter: filter, categoryId: categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          return TaskListWidget(
            tasks: taskProvider.filteredTasks,
            onEdit: (task) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)));
            },
            onToggleComplete: (task) async => await taskProvider.toggleComplete(task.id),
            onDelete: (task) async => await taskProvider.removeTask(task.id),
          );
        },
      ),
    );
  }
}
