import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FedoMusicApp());
}

class FedoMusicApp extends StatelessWidget {
  const FedoMusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fedo Music Pro',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatelessWidget {
  const MusicHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fedo Music Pro'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_rounded, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text(
              'Fedo Music Pro İşləyir!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
