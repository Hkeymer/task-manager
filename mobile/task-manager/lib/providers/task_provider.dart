import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Task> tasks = [];
  Future<void> loadTasks() async {
    final data = await _api.getTasksUser();
    tasks = data.map((e) => Task.fromJson(e)).toList();
    notifyListeners();
  }

  Future<bool> addTask(String title, String? desc, String? categoryId) async {
    final res = await _api.createTask(
        {'title': title, 'description': desc, 'categoryId': categoryId});
    if (res['status'] == 201 || res['status'] == 200) {
      await loadTasks();
      return true;
    }
    return false;
  }

  Future<bool> updateTask(String id, Map<String, dynamic> body) async {
    final res = await _api.patchTask(id, body);
    if (res['status'] == 200) {
      await loadTasks();
      return true;
    }
    return false;
  }

  Future<bool> removeTask(String id) async {
    final res = await _api.deleteTask(id);
    if (res['status'] == 200 || res['status'] == 204) {
      tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> toggleComplete(String id) async {
    await _api.toggleComplete(id);
    await loadTasks();
  }

  Future<void> toggleFavorite(String id) async {
    await _api.toggleFavorite(id);
    await loadTasks();
  }
}
