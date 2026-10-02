import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const FedoMusicApp());
}

class FedoMusicApp extends StatelessWidget {
  const FedoMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fedo Music Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.green,
      ),
      home: const MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String currentStatus = "Mahnı seçilməyib";

  // Test üçün nümunə audio URL-i
  final String sampleUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Player vəziyyətini izləyirik
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
        if (state.playing) {
          currentStatus = "Mahnı səsləndirilir...";
        } else if (state.processingState == ProcessingState.completed) {
          currentStatus = "Mahnı bitdi";
        } else {
          currentStatus = "Mahnı dayandırıldı";
        }
      });
    });
  }

  Future<void> _playAudio() async {
    try {
      if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
        await _audioPlayer.setUrl(sampleUrl);
      }
      await _audioPlayer.play();
    } catch (e) {
      setState(() {
        currentStatus = "Xəta baş verdi: Mahnı tapılmadı";
      });
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fedo Music Pro'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.music_note_rounded,
                size: 100,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 30),
              Text(
                currentStatus,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: isPlaying ? null : _playAudio,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Oxut"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: isPlaying ? _pauseAudio : null,
                    icon: const Icon(Icons.pause),
                    label: const Text("Saxla"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
