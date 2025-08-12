import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import 'task_form_screen.dart';
import '../widgets/task_item.dart';
class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState()=>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<TaskProvider>(context,listen:false).loadTasks();
    });
  }
  @override
  Widget build(BuildContext context){
    final tasksProv = Provider.of<TaskProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis tareas'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: ()=>auth.logout()),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=>tasksProv.loadTasks(),
        child: ListView.builder(
          itemCount: tasksProv.tasks.length,
          itemBuilder: (_,i)=>TaskItem(task: tasksProv.tasks[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>TaskFormScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
