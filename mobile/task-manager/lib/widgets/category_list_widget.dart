import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoryListWidget extends StatelessWidget {
  final Function(Map<String, dynamic>)? onEdit; // callback para editar categoría
  final Function()? onCreate; // callback para crear nueva categoría

  const CategoryListWidget({Key? key, this.onEdit, this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        // Loader
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.errorMessage!,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => provider.loadCategories(),
                  child: const Text("Reintentar"),
                ),
              ],
            ),
          );
        }

        // Lista vacía
        if (provider.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No hay categorías disponibles"),
                const SizedBox(height: 10),
                if (onCreate != null)
                  ElevatedButton(
                    onPressed: onCreate,
                    child: const Text("Crear categoría"),
                  ),
              ],
            ),
          );
        }

        // Lista de categorías
        return ListView.builder(
          itemCount: provider.categories.length,
          itemBuilder: (context, index) {
            final cat = provider.categories[index];

            // Opcional: evita mostrar "Sin categoría"
            if (cat['name'] == "Sin categoría") return const SizedBox();

            return ListTile(
              title: Text(cat['name']),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onEdit?.call(cat);
                },
              ),
            );
          },
        );
      },
    );
  }
}
