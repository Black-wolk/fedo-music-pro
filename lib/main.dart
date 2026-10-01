import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FedoMusicProApp());
}

class FedoMusicProApp extends StatelessWidget {
  const FedoMusicProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Music Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurple,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
