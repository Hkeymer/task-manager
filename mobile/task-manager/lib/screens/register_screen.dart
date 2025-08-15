import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
class RegisterScreen extends StatefulWidget{
  @override
  _RegisterScreenState createState()=>_RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen>{
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading=false;
  @override
  Widget build(BuildContext context){
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key:_formKey,
          child: Column(
            children:[
              TextFormField(controller:_name, decoration: InputDecoration(labelText:'Nombre'), validator: (v)=>v!=null && v.isNotEmpty?null:'Requerido'),
              SizedBox(height:12),
              TextFormField(controller:_email, decoration: InputDecoration(labelText:'Email'), validator: (v)=>v!=null && v.contains('@')?null:'Ingrese email válido'),
              SizedBox(height:12),
              TextFormField(controller:_password, decoration: InputDecoration(labelText:'Contraseña'), obscureText:true, validator:(v)=>v!=null && v.length>=6?null:'Mínimo 6 caracteres'),
              SizedBox(height:20),
              ElevatedButton(
                onPressed: _loading?null:() async{
                  if(!_formKey.currentState!.validate()) return;
                  setState(()=>_loading=true);
                  final ok = await auth.register(_email.text.trim(), _password.text.trim(), _name.text.trim());
                  setState(()=>_loading=false);
                  if(ok) Navigator.pop(context);
                  else showDialog(context: context, builder: (_)=>AlertDialog(content: Text('Error al registrar')));
                },
                child: _loading?CircularProgressIndicator(color: Colors.white):Text('Registrar')
              ),
            ]
          )
        )
      )
    );
  }
}
