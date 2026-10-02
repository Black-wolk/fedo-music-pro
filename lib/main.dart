import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const FedoAutoMusicApp());
}

class FedoAutoMusicApp extends StatelessWidget {
  const FedoAutoMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Musiqi Auto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
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
  String _statusText = "Səsli əmr vermək üçün mikrofon düyməsinə basın";
  
  YoutubePlayerController? _controller;
  String? _currentVideoId;

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
          _statusText = "Dinlənilir... Mahnı və ya video adını deyin";
        });
        _speech.listen(
          localeId: "az_AZ", // Azərbaycan dilində səsli axtarış
          onResult: (val) {
            setState(() {
              if (val.recognizedWords.isNotEmpty) {
                _statusText = "Axtarılır: \"${val.recognizedWords}\"";
                _playMusicOrVideo(val.recognizedWords);
              }
            });
          },
        );
      } else {
        setState(() => _statusText = "Səsli tanımaq dəstəklənmir və ya icazə verilməyib");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _playMusicOrVideo(String query) {
    // Səsli əmr gəldikdə nümunə videolar və ya axtarış parametri yüklənir
    // Avto rejim üçün idarəetmə sadələşdirilmişdir
    setState(() {
      _currentVideoId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
      
      if (_controller == null) {
        _controller = YoutubePlayerController(
          initialVideoId: _currentVideoId ?? 'dQw4w9WgXcQ',
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: false,
          ),
        );
      } else {
        _controller!.load(_currentVideoId!);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fedo Auto Music & Video', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.redDark,
      ),
      body: Column(
        children: [
          // Video/Musiqi Pleyer Zonası (Maşın ekranı üçün böyük ölçü)
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
              ),
              child: _controller != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 80, color: Colors.redAccent),
                          SizedBox(height: 12),
                          Text(
                            "Mahnı və ya Video Səsli Əmrlə Başladılacaq",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          // Status paneli
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isListening ? Colors.greenAccent : Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Maşın sürərkən rahat basmaq üçün Böyük Səsli Mikrofon Düyməsi
          Expanded(
            flex: 2,
            child: Center(
              child: GestureDetector(
                onTap: _listen,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isListening ? 130 : 110,
                  height: _isListening ? 130 : 110,
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.red : Colors.redAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isListening ? Colors.red.withOpacity(0.8) : Colors.redAccent.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: _isListening ? 10 : 3,
                      )
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
