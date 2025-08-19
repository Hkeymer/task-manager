class Category {
  final int id;
  final String name;
  final int userId;

  Category({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'] ?? '',
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'userId': userId,
      };
}
