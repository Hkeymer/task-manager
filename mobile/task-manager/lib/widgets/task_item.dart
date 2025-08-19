import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
class TaskItem extends StatelessWidget{
  final Task task;
  TaskItem({required this.task});
  @override
  Widget build(BuildContext context){
    final prov = Provider.of<TaskProvider>(context, listen:false);
    return ListTile(
      title: Text(task.title, style: TextStyle(decoration: task.isCompleted?TextDecoration.lineThrough:TextDecoration.none)),
      subtitle: task.description!=null?Text(task.description!):null,
      leading: IconButton(icon: Icon(Icons.star), onPressed: ()=>prov.toggleFavorite(task.id)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children:[
        IconButton(icon: Icon(task.isCompleted?Icons.check_box:Icons.check_box_outline_blank), onPressed: ()=>prov.toggleComplete(task.id)),
        IconButton(icon: Icon(Icons.delete), onPressed: ()=>prov.removeTask(task.id)),
      ]),
    );
  }
}
