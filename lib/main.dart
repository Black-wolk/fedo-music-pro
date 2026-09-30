
// lib/main.dart
import 'package:flutter/material.dart';
import 'ui/player_screen.dart';

void main() {
  runApp(const FedoMusicApp());
}

class FedoMusicApp extends StatelessWidget {
  const FedoMusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Music Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FedoPlayerScreen(),
    );
  }
}
