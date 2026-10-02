import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
      home: const VoicePlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class VoicePlayerScreen extends StatefulWidget {
  const VoicePlayerScreen({Key? key}) : super(key: key);

  @override
  State<VoicePlayerScreen> createState() => _VoicePlayerScreenState();
}

class _VoicePlayerScreenState extends State<VoicePlayerScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _statusText = "Fedo Music Pro Hazırdır!";
  String _lastCommand = "";
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermissions();
    _initAudio();
  }

  void _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  void _initAudio() async {
    try {
      // Test üçün internetdəki açıq musiqi linki (sonradan telefon yaddaşına qoşulacaq)
      await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    } catch (e) {
      setState(() => _statusText = "Musiqi yüklənmədi: $e");
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => setState(() => _statusText = "Status: $status"),
      onError: (error) => setState(() => _statusText = "Xəta: ${error.errorMsg}"),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _statusText = "Dinlənilir... Danış!";
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastCommand = result.recognizedWords;
            _processCommand(_lastCommand);
          });
        },
        localeId: "az_AZ",
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
      _statusText = "Dinləmə dayandırıldı.";
    });
  }

  void _processCommand(String command) {
    String cmd = command.toLowerCase();
    if (cmd.contains("oxut") || cmd.contains("başla") || cmd.contains("qoş")) {
      _audioPlayer.play();
      setState(() => _statusText = "Mahnı səsləndirilir: $cmd");
    } else if (cmd.contains("saxla") || cmd.contains("dayandır")) {
      _audioPlayer.pause();
      setState(() => _statusText = "Mahnı dayandırıldı.");
    }
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
        title: const Text('Fedo Music Pro - Səsli Pleyer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Son eşidilən əmr: '$_lastCommand'",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            FloatingActionButton.large(
              onPressed: _isListening ? _stopListening : _startListening,
              backgroundColor: _isListening ? Colors.red : Colors.blue,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              _isListening ? "Dinləyirəm... (Məs: 'Oxut' və ya 'Saxla de')" : "Mikrofon düyməsinə bas və danış",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _audioPlayer.play(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Çal"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _audioPlayer.pause(),
                  icon: const Icon(Icons.pause),
                  label: const Text("Pauza"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
