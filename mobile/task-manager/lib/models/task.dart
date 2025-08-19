import 'category.dart';

class Task {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int? categoryId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.categoryId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        isCompleted: json['isCompleted'] ?? false,
        categoryId: json['categoryId'],
        userId: json['userId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        category: json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'categoryId': categoryId,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'category': category?.toJson(),
      };
}


