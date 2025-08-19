import 'package:flutter/material.dart';
import 'package:task_manager/services/api_service.dart';
import 'package:task_manager/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService;

  CategoryProvider({CategoryService? categoryService})
      : _categoryService = categoryService ?? CategoryService(ApiService());

  List<dynamic> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories({bool showLoader = true}) async {
    if (showLoader) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final data = await _categoryService.getCategories();
      _categories = data;
    } catch (e) {
      _errorMessage = "No se pudieron cargar las categorías. Intenta de nuevo.";
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(Map<String, dynamic> data) async {
    try {
      await _categoryService.createCategory(data);
      await loadCategories(showLoader: false);
    } catch (e) {
      _errorMessage = "Error al crear categoría.";
      notifyListeners();
    }
  }

  Future<void> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      await _categoryService.patchCategory(id, data);
      await loadCategories(showLoader: false);
    } catch (e) {
      _errorMessage = "Error al actualizar categoría.";
      notifyListeners();
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((c) => c['id'] == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al eliminar categoría.";
      notifyListeners();
    }
  }
}


