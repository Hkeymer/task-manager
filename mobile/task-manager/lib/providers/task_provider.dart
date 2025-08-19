import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/api_service.dart';
import '../exceptions/task_exception.dart';
import 'auth_provider.dart';

class TaskProvider extends ChangeNotifier {
  // ------------------- Servicios -------------------
  final TaskService _taskService;

  // ------------------- Estado interno -------------------
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider? _authProvider;

  // ------------------- Constructor -------------------
  TaskProvider({TaskService? taskService})
      : _taskService = taskService ?? TaskService(ApiService());

  // ------------------- Getters -------------------
  List<Task> get tasks => _tasks;
  List<Task> get filteredTasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateAuthProvider(AuthProvider provider) {
    _authProvider = provider;
  }

  // ------------------- Cargar tareas -------------------
  Future<void> loadTasks({String? filter, int? categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Task> allTasks = await _taskService.getMyTasks();

      // Filtrar pendientes
      if (filter == 'pending') {
        allTasks = allTasks.where((t) => !t.isCompleted).toList();
      }

      // Filtrar favoritas según el usuario actual
      if (filter == 'favorite' && _authProvider?.user != null) {
        final favIds = _authProvider!.user!.favorites;
        allTasks = allTasks.where((t) => favIds.contains(t.id)).toList();
      }

      // Filtrar por categoría
      if (categoryId != null) {
        allTasks = allTasks.where((t) => t.categoryId == categoryId).toList();
      }

      _tasks = allTasks;
      _filteredTasks = allTasks;
    } on TaskException catch (e) {
      _tasks = [];
      _filteredTasks = [];
      _errorMessage = "Error cargando tareas: ${e.message}";
      print(_errorMessage);
    } catch (e) {
      _tasks = [];
      _filteredTasks = [];
      _errorMessage = "Error inesperado al cargar tareas";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------- Operaciones CRUD -------------------
  Future<Task?> getTaskById(int id) async {
    try {
      return await _taskService.getTaskById(id);
    } on TaskException catch (e) {
      _errorMessage = "Error obteniendo tarea: ${e.message}";
      print(_errorMessage);
      return null;
    }
  }

  Future<bool> addTask(String title, String description, int? categoryId) async {
    try {
      final taskMap = {'title': title, 'description': description, 'categoryId': categoryId};
      final res = await _taskService.createTask(taskMap);

      if (res['status'] == 200 || res['status'] == 201) {
        await loadTasks();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Error agregando tarea";
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> updateTask(int id, Map<String, dynamic> data) async {
    try {
      final res = await _taskService.patchTask(id, data);

      if (res['status'] == 200 || res['status'] == 204) {
        await loadTasks();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Error actualizando tarea";
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> removeTask(int id) async {
    try {
      final res = await _taskService.deleteTask(id);

      if (res['status'] == 200 || res['status'] == 204) {
        _tasks.removeWhere((t) => t.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = "Error eliminando tarea";
      print(_errorMessage);
      return false;
    }
  }

  // ------------------- Acciones auxiliares -------------------
  Future<void> toggleComplete(int id) async {
    try {
      await _taskService.toggleComplete(id);
      await loadTasks();
    } catch (e) {
      _errorMessage = "Error marcando tarea completada";
      print(_errorMessage);
    }
  }

  Future<void> toggleFavorite(int taskId) async {
    try {
      await _taskService.toggleFavorite(taskId);

      if (_authProvider != null) {
        await _authProvider!.loadUser();
      }

      await loadTasks();
    } catch (e) {
      _errorMessage = "Error actualizando favorita";
      print(_errorMessage);
    }
  }
}
 



