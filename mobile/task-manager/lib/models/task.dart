class Task{
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final bool favorite;
  final String? categoryId;
  Task({required this.id, required this.title, this.description, required this.completed, required this.favorite, this.categoryId});
  factory Task.fromJson(Map<String,dynamic> j)=>Task(
    id: j['id'].toString(),
    title: j['title'] ?? '',
    description: j['description'],
    completed: j['completed'] == true,
    favorite: j['favorite'] == true,
    categoryId: j['categoryId'] != null ? j['categoryId'].toString() : null
  );
  Map<String,dynamic> toJson()=>{
    'title': title,
    'description': description,
    'completed': completed,
    'favorite': favorite,
    'categoryId': categoryId
  };
}
