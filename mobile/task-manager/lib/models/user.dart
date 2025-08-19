import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? refreshToken;
  final List<int> tasks;
  final List<int> categories;
  final List<int> favorites;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.refreshToken,
    required this.tasks,
    required this.categories,
    required this.favorites,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'USER',
        refreshToken: json['refreshToken'],
        tasks: List<int>.from(json['tasks'].map((e) => e['id'] as int) ?? []),
        categories: List<int>.from(json['categories'].map((e) => e['id'] as int) ?? []),
        favorites: List<int>.from(json['favorites'].map((e) => e['id'] as int) ?? []),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'refreshToken': refreshToken,
        'tasks': tasks,
        'categories': categories,
        'favorites': favorites,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
