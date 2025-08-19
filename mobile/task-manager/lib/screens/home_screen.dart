import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/widgets/app_drawer.dart';
import '../providers/auth_provider.dart';
import '../screens/task_form_screen.dart';
import '../widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final  taskProv= Provider.of<TaskProvider>(context, listen: false);
      final cateProv = Provider.of<CategoryProvider>(context, listen: false);
      final authProv = Provider.of<AuthProvider>(context, listen: false);

      taskProv.updateAuthProvider(authProv);

      // Cargar categorías y tareas
      await cateProv.loadCategories();
      await taskProv.loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis tareas'),
      ),
      drawer: AppDrawer(),
      body: taskProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => taskProv.loadTasks(),
              child: TaskListWidget(tasks: taskProv.filteredTasks),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskFormScreen()),
          );
          if (created == true) {
            await taskProv.loadTasks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
