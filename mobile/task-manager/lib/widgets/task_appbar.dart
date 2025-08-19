import 'package:flutter/material.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onSave;
  final bool isEditing;

  const TaskAppBar({
    super.key,
    required this.onBack,
    required this.onUndo,
    required this.onRedo,
    required this.onSave,
    this.isEditing = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
  backgroundColor: Colors.black,
  elevation: 2,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: onBack,
  ),
  title: Text(isEditing ? "Editar Tarea" : "Nueva Tarea"),
  actions: [
    IconButton(
      icon: Icon(Icons.save, color: Colors.greenAccent),
      onPressed: onSave,
    ),
  ],
) ;

  }
}
