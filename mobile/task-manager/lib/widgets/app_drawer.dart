import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/create_edit_category_screen.dart';
import '../screens/task_list_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context);


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // HEADER
          UserAccountsDrawerHeader(
            accountName: Text(authProvider.user?.name ?? 'Usuario'),
            accountEmail: Text(authProvider.user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                authProvider.user?.name[0].toUpperCase() ?? 'U',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              backgroundColor: Colors.blueAccent,
            ),
          ),

          // SECCIÓN 1: Tareas rápidas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Tareas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.pending_actions),
            title: Text('Tareas pendientes (2)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskListScreen(filter: 'pending'),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Tareas favoritas (5)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskListScreen(filter: 'favorite'),
                ),
              );
            },
          ),

          Divider(),

          // SECCIÓN 2: Categorías dinámicas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Categorías',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          ...categoryProvider.categories.map((category) {
            return ListTile(
              leading: Icon(Icons.label),
              title: Text('${category.name} (${category.taskCount})'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TaskListScreen(categoryId: category.id),
                  ),
                );
              },
            );
          }).toList(),

          Divider(),

          // SECCIÓN 3: Editar categorías
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar categorías'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateEditCategoryScreen(),
                ),
              );
            },
          ),

          Divider(),

          // SECCIÓN 4: Cerrar sesión
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Cerrar sesión"),
                    content: Text(
                        "¿Estás seguro de que deseas cerrar sesión?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text("Cerrar sesión"),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout == true) {
                await authProvider.logout();
                // Limpiar historial y volver a login
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
