import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const FedoAutoApp());
}

class FedoAutoApp extends StatelessWidget {
  const FedoAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Auto Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      home: const AutoHomeScreen(),
    );
  }
}

class AutoHomeScreen extends StatefulWidget {
  const AutoHomeScreen({super.key});

  @override
  State<AutoHomeScreen> createState() => _AutoHomeScreenState();
}

class _AutoHomeScreenState extends State<AutoHomeScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _status = "Səsli əmr vermək üçün düyməyə basın";
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );

      if (available) {
        setState(() {
          _isListening = true;
          _status = "Dinlənilir... Mahnı adını deyin";
        });
        _speech.listen(
          localeId: "az_AZ",
          onResult: (val) {
            if (val.recognizedWords.isNotEmpty) {
              setState(() {
                _status = "Axtarılır: ${val.recognizedWords}";
                _loadVideo("dQw4w9WgXcQ"); // Nümunə video ID
              });
            }
          },
        );
      } else {
        setState(() => _status = "Mikrofon icazəsi verilməyib");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _loadVideo(String videoId) {
    if (_controller == null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      _controller!.load(videoId);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Monitor üçün Böyük Pleyer Sahəsi
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent, width: 2),
                ),
                child: _controller != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: YoutubePlayer(controller: _controller!),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_fill, size: 90, color: Colors.redAccent),
                            SizedBox(height: 10),
                            Text(
                              "Səsli Əmrlə Musiqi və Video Oxutma",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            // Status Bildirişi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _status,
                style: TextStyle(
                  color: _isListening ? Colors.greenAccent : Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),

            // Avtomobil üçün Böyük Səs Düyməsi
            Expanded(
              flex: 2,
              child: Center(
                child: GestureDetector(
                  onTap: _listen,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.red : Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 65,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
