import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/category_provider.dart';

class CategoryDropdown extends StatelessWidget {
  final int? selectedCategory;
  final Function(int?) onChanged;

  const CategoryDropdown({Key? key, this.selectedCategory, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cateProv = Provider.of<CategoryProvider>(context);


    if (cateProv.isLoading) {
      return const CircularProgressIndicator();
    }

    if (cateProv.categories.isEmpty) {
      return const Text('No hay categorías disponibles');
    }

    return DropdownButtonFormField<int>(
      value: selectedCategory ?? (cateProv.categories.isNotEmpty ? cateProv.categories.first['id'] : null),
      items: cateProv.categories
          .map<DropdownMenuItem<int>>(
            (c) => DropdownMenuItem<int>(
              value: c['id'],
              child: Text(c['name']),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: 'Categoría'),
    );
  }
}
