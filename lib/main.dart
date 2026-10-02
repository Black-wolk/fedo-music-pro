import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const FedoMusicProApp());
}

class FedoMusicProApp extends StatelessWidget {
  const FedoMusicProApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Music Pro',
      theme: ThemeData.dark(),
      home: const PlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _status = "Fedo Music Pro Hazırdır!";

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    await Permission.storage.request();
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fedo Music Pro'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _status = "Mahnı səsləndirilir...";
                });
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Oxut"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _audioPlayer.pause();
                setState(() {
                  _status = "Mahnı dayandırıldı.";
                });
              },
              icon: const Icon(Icons.pause),
              label: const Text("Saxla"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
