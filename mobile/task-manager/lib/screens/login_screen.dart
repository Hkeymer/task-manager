import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '../exceptions/auth_exception.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  void _showSnackBar(String message, {bool error = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: error ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(12),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Ingrese email válido',
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _loading = true);

                        try {
                          final ok = await auth.login(
                            _email.text.trim(),
                            _password.text.trim(),
                          );

                          setState(() => _loading = false);

                          if (ok) {
                            _showSnackBar("Inicio de sesión exitoso ✅");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeScreen()),
                            );
                          }
                        } on AuthException catch (e) {
                          setState(() => _loading = false);
                          _showSnackBar(e.message, error: true);
                        }
                      },
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Ingresar'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                ),
                child: Text('Crear cuenta'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

