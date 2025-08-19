import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryFormPopup extends StatefulWidget {
  final Category? category;

  const CategoryFormPopup({super.key, this.category});

  @override
  State<CategoryFormPopup> createState() => _CategoryFormPopupState();
}

class _CategoryFormPopupState extends State<CategoryFormPopup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);

    return AlertDialog(
      title: Text(widget.category == null ? 'Crear categoría' : 'Editar categoría'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingrese un nombre';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final name = _nameController.text.trim();
              if (widget.category == null) {
                categoryService.createCategory({'name': name});
              } else {
                categoryService.patchCategory(widget.category!.id, {'name': name});
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.category == null ? 'Crear' : 'Guardar'),
        ),
      ],
    );
  }
}
