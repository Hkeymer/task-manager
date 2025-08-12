class Category{
  final String id;
  final String name;
  Category({required this.id, required this.name});
  factory Category.fromJson(Map<String,dynamic> j)=>Category(id: j['id'].toString(), name: j['name'] ?? '');
}
