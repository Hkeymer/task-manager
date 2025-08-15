import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../services/api_service.dart';

class TaskFormScreen extends StatefulWidget {
  final String? taskId;
  TaskFormScreen({this.taskId});
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  bool _loading = false;

  List<dynamic> _categories = [];
  dynamic _selectedCategory;

  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    try {
      final categories = await _api.getCategories();
      print(categories);
      setState(() {
        _categories = categories;
        _selectedCategory = categories.isNotEmpty ? categories[0] : null;
      });
    } catch (e) {
      print("Error cargando categorías: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TaskProvider>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Crear tarea')),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: _title,
                      decoration: InputDecoration(labelText: 'Título'),
                      validator: (v) =>
                          v != null && v.isNotEmpty ? null : 'Requerido'),
                  SizedBox(height: 12),
                  TextFormField(
                      controller: _desc,
                      decoration: InputDecoration(labelText: 'Descripción')),
                  SizedBox(height: 20),
                  DropdownButtonFormField<dynamic>(
                    value: _selectedCategory,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Categoría'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _loading = true);
                              final ok = await prov.addTask(
                                  _title.text.trim(), _desc.text.trim(), null);
                              setState(() => _loading = false);
                              if (ok)
                                Navigator.pop(context);
                              else
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        content: Text('Error al crear tarea')));
                            },
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Guardar'))
                ]))));
  }
}
