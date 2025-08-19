import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/category_provider.dart';
import '../widgets/category_list_widget.dart';

class CreateEditCategoryScreen extends StatefulWidget {
  const CreateEditCategoryScreen({super.key});

  @override
  State<CreateEditCategoryScreen> createState() =>
      _CreateEditCategoryScreenState();
}

class _CreateEditCategoryScreenState extends State<CreateEditCategoryScreen> {
  @override
  void initState() {
    super.initState();
    final cateProv = Provider.of<CategoryProvider>(context, listen: false);
    cateProv.loadCategories();
  }

  void _openCategoryForm([Map<String, dynamic>? category]) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
            text: category != null ? category['name'] : '');
        return AlertDialog(
          title:
              Text(category != null ? "Editar categoría" : "Crear categoría"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                final provider =
                    Provider.of<CategoryProvider>(context, listen: false);

                if (category != null) {
                  await provider.updateCategory(category['id'], {'name': name});
                } else {
                  await provider.addCategory({'name': name});
                }

                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openCategoryForm(),
          ),
        ],
      ),
      body: CategoryListWidget(
        onEdit: (cat) => _openCategoryForm(cat),
        onCreate: () => _openCategoryForm(),
      ),
    );
  }
}
