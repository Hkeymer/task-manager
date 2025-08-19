import 'dart:convert';
import '../exceptions/task_exception.dart';
import '../models/task.dart';
import 'api_service.dart';

class TaskService {
  final ApiService _api;

  TaskService(this._api);

  Future<List<Task>> getMyTasks() async {
    final res = await _api.request('GET', '/api/v1/tasks/my-tasks');
    if (res.statusCode == 200 || res.statusCode == 201) {
      final List data = json.decode(res.body);
      return data.map((e) => Task.fromJson(e)).toList();
    }
    throw TaskException('Error al obtener tareas');
  }

  Future<Task> getTaskById(int id) async {
    final res = await _api.request('GET', '/api/v1/tasks/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Task.fromJson(json.decode(res.body));
    }
    throw TaskException('Error al cargar la tarea');
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    final res = await _api.request('POST', '/api/v1/tasks', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> patchTask(
      int id, Map<String, dynamic> data) async {
    final res = await _api.request('PATCH', '/api/v1/tasks/$id', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> deleteTask(int id) async {
    final res = await _api.request('DELETE', '/api/v1/tasks/$id');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<List<Task>> getByCategory(int id) async {
    final res = await _api.request('GET', '/api/v1/tasks/category/$id');
    if (res.statusCode == 200 || res.statusCode == 201) {
      final List data = json.decode(res.body);
      return data.map((e) => Task.fromJson(e)).toList();
    }
    throw TaskException('Error al obtener tareas por categoría');
  }

  Future<List<Task>> getPending() async =>
      _mapTaskList(await _api.request('GET', '/api/v1/tasks/pending'));

  Future<List<Task>> getCompleted() async =>
      _mapTaskList(await _api.request('GET', '/api/v1/tasks/completed'));

  Future<List<Task>> getFavorites() async =>
      _mapTaskList(await _api.request('GET', '/api/v1/tasks/favorites'));

  Future<Map<String, dynamic>> toggleComplete(int id) async {
    final res = await _api.request('PATCH', '/api/v1/tasks/$id/completed');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> toggleFavorite(int id) async {
    final res = await _api.request('PATCH', '/api/v1/tasks/$id/favorite');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> toggleAllCompleted() async {
    final res =
        await _api.request('PATCH', '/api/v1/tasks/completed/toggle-all');
    return {'status': res.statusCode, 'body': res.body};
  }

  List<Task> _mapTaskList(dynamic res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      final List data = json.decode(res.body);
      return data.map((e) => Task.fromJson(e)).toList();
    }
    throw TaskException('Error en la petición');
  }
}
