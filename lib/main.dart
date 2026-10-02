import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const FedoApp());

class FedoApp extends StatelessWidget {
  const FedoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedo Musiqi Pro',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _stt = SpeechToText();
  bool _ready = false;
  bool _listening = false;
  String _heard = '';
  String _status = 'Mikrofona basın və "Fedo, mahnı adı" deyin';
  String? _localeId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _ready = await _stt.initialize();
    if (_ready) {
      final locales = await _stt.locales();
      for (final l in locales) {
        if (l.localeId.toLowerCase().startsWith('az')) {
          _localeId = l.localeId;
          break;
        }
      }
    } else {
      _status = 'Mikrofon icazəsi verilmədi';
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggle() async {
    if (!_ready) return;
    if (_listening) {
      await _stt.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _listening = true;
      _heard = '';
      _status = 'Dinləyirəm...';
    });
    await _stt.listen(
      localeId: _localeId,
      onResult: (r) {
        setState(() => _heard = r.recognizedWords);
        if (r.finalResult) {
          setState(() => _listening = false);
          _handle(r.recognizedWords);
        }
      },
    );
  }

  Future<void> _handle(String text) async {
    final t = text.toLowerCase();
    if (!t.contains('fedo')) {
      setState(() => _status = 'Əvvəl "Fedo" deyin');
      return;
    }
    final cmd = t.replaceAll('fedo', '').trim();
    if (cmd.contains('dayan')) {
      setState(() => _status = 'Dayandırıldı');
    } else if (cmd.contains('dəyiş') || cmd.contains('deyis')) {
      setState(() => _status = 'Növbəti mahnı (tezliklə)');
    } else if (cmd.isNotEmpty) {
      setState(() => _status = 'Axtarılır: $cmd');
      final uri = Uri.https(
          'www.youtube.com', '/results', {'search_query': cmd});
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      setState(() => _status = 'Mahnı adını da deyin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fedo Musiqi Pro')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text(_heard,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _toggle,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _listening ? Colors.red : Colors.deepPurple,
                  child: Icon(_listening ? Icons.stop : Icons.mic, size: 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
