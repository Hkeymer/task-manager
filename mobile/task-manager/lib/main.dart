import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("No se pudo cargar .env: $e");
  }
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'task-manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Root(),
      ),
    );
  }
}
class Root extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final auth = Provider.of<AuthProvider>(context);
    if(auth.isAuthenticated){
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
