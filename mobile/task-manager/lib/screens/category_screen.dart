import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
class CategoryScreen extends StatefulWidget{
  @override
  _CategoryScreenState createState()=>_CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen>{
  final ApiService _api = ApiService();
  List _cats = [];
  final _name = TextEditingController();
  @override
  void initState(){
    super.initState();
    _load();
  }
  void _load() async{
    final data = await _api.getCategories();
    setState(()=>_cats = data);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Categorías')),
      body: Column(children:[
        Padding(padding: EdgeInsets.all(8), child: Row(children:[
          Expanded(child: TextField(controller:_name, decoration: InputDecoration(labelText:'Nombre'))),
          ElevatedButton(onPressed: () async{
            if(_name.text.trim().isEmpty) return;
            await _api.createCategory({'name':_name.text.trim()});
            _name.clear();
            _load();
          }, child: Text('Crear'))
        ])),
        Expanded(child: ListView.builder(itemCount:_cats.length,itemBuilder:(_,i){
          final c = _cats[i];
          return ListTile(title: Text(c['name'] ?? ''), trailing: Row(mainAxisSize: MainAxisSize.min, children:[
            IconButton(icon: Icon(Icons.edit), onPressed: (){}),
            IconButton(icon: Icon(Icons.delete), onPressed: () async{
              await _api.deleteCategory(c['id'].toString());
              _load();
            })
          ]));
        }))
      ])
    );
  }
}
