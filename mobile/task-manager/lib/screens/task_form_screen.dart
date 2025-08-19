import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/category_dropdown.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({this.task, Key? key}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  int? _selectedCategory;
  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final cateProv = Provider.of<CategoryProvider>(context, listen: false);

    if (isEditing) _loadTask();
    _selectedCategory ??=
        cateProv.categories.isNotEmpty ? cateProv.categories.first['id'] : null;
  }

  void _loadTask() {
    _title.text = widget.task!.title;
    _desc.text = widget.task!.description ?? '';
    _selectedCategory = widget.task!.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (isEditing) {
                await taskProv.updateTask(widget.task!.id, {
                  'title': _title.text,
                  'description': _desc.text,
                  'categoryId': _selectedCategory
                });
              } else {
                await taskProv.addTask(
                    _title.text, _desc.text, _selectedCategory);
              }
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 12),
            CategoryDropdown(
              selectedCategory: _selectedCategory,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _desc,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
