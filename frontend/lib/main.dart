import 'package:flutter/material.dart';
import 'views/pages/screen_page.dart';
import 'views/pages/home_page.dart';
import 'views/pages/login_page.dart';
import 'views/pages/register_page.dart';
import 'views/pages/profile_page.dart';
import 'views/pages/allergies_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPHC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ScreenPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/allergies': (context) => const AllergiesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
