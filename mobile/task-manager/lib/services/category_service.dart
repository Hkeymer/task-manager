import 'dart:convert';
import 'api_service.dart';

class CategoryService {
  final ApiService _api;

  CategoryService(this._api);

  Future<List<dynamic>> getCategories() async {
    final res = await _api.request('GET', '/api/v1/categories');
    if (res.statusCode == 200 || res.statusCode == 201) {
      return json.decode(res.body);
    }
    throw Exception('Error al obtener categorías');
  }

Future<String?> getCategoryName(int id) async {
  final res = await _api.request('GET', '/api/v1/categories/$id');

  if (res.statusCode == 200 || res.statusCode == 201) {
    final category = json.decode(res.body);
    return category['name']; // ajusta si el campo se llama diferente
  }
  return null;
}
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    final res = await _api.request('POST', '/api/v1/categories', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> patchCategory(
      int id, Map<String, dynamic> data) async {
    final res =
        await _api.request('PATCH', '/api/v1/categories/$id', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    final res = await _api.request('DELETE', '/api/v1/categories/$id');
    return {'status': res.statusCode, 'body': res.body};
  }
}
