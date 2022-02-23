import 'package:flutter/material.dart';
import 'package:flutter_miarmapp/ui/login_screen.dart';
import 'package:flutter_miarmapp/ui/menu_screen.dart';
import 'package:flutter_miarmapp/ui/profile_screen.dart';
import 'package:flutter_miarmapp/ui/register_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MiarmApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
  routes: {
    '/menu': (context) => const MenuScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/profile': (context) => const ProfileScreen()
  },
    );
  }
}