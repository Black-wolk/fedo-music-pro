import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart';

const String jamendoClientId = '';

class Track {
  final String title;
  final String artist;
  final String url;
  Track(this.title, this.artist, this.url);
}

Future<List<Track>> searchTracks(String q) async {
  final out = <Track>[];
  if (jamendoClientId.isNotEmpty) {
    try {
      final r = await http.get(Uri.https('api.jamendo.com', '/v3.0/tracks/', {
        'client_id': jamendoClientId,
        'format': 'json',
        'limit': '10',
        'search': q,
        'audioformat': 'mp31',
      }));
      final j = jsonDecode(r.body);
      for (final t in j['results']) {
        final a = (t['audio'] ?? '').toString();
        if (a.isNotEmpty) {
          out.add(Track(t['name'].toString(), t['artist_name'].toString(), a));
        }
      }
    } catch (_) {}
  }
  if (out.isEmpty) {
    try {
      final r = await http.get(Uri.https('itunes.apple.com', '/search', {
        'term': q,
        'media': 'music',
        'entity': 'song',
        'limit': '10',
      }));
      final j = jsonDecode(r.body);
      for (final t in j['results']) {
        final p = t['previewUrl'];
        if (p != null) {
          out.add(Track(
              t['trackName'].toString(), t['artistName'].toString(), p));
        }
      }
    } catch (_) {}
  }
  return out;
}

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
  final AudioPlayer _player = AudioPlayer();
  bool _ready = false;
  bool _auto = false; // daimi dinləmə rejimi
  bool _busy = false;
  String _heard = '';
  String _status = 'Daimi dinləməni açın və "Fedo, mahnı adı" deyin';
  String? _localeId;
  List<Track> _tracks = [];
  int _index = 0;

  static const _fillers = {
    'mahnı', 'mahni', 'mahmu', 'mahnu', 'qoş', 'qos', 'boş', 'bos',
    'oxu', 'çal', 'cal', 'tap', 'axtar', 'aç', 'ac', 'zəhmət', 'olmasa',
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _auto = false;
    _stt.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _ready = await _stt.initialize(
      onStatus: (s) {
        if (_auto && !_busy && (s == 'done' || s == 'notListening')) {
          Future.delayed(const Duration(milliseconds: 600), _listenLoop);
        }
      },
      onError: (e) {
        if (_auto && !_busy) {
          Future.delayed(const Duration(seconds: 1), _listenLoop);
        }
      },
    );
    if (_ready) {
      final locales = await _stt.locales();
      String? tr;
      for (final l in locales) {
        final id = l.localeId.toLowerCase();
        if (id.startsWith('az')) {
          _localeId = l.localeId;
          break;
        }
        if (id.startsWith('tr')) tr = l.localeId;
      }
      _localeId ??= tr;
    } else {
      _status = 'Mikrofon icazəsi verilmədi';
    }
    if (mounted) setState(() {});
  }

  Future<void> _toggleAuto() async {
    if (!_ready) return;
    if (_auto) {
      _auto = false;
      await _stt.cancel();
      setState(() => _status = 'Daimi dinləmə söndürüldü');
    } else {
      _auto = true;
      setState(() => _status = 'Dinləyirəm... "Fedo" deyin');
      _listenLoop();
    }
  }

  Future<void> _listenLoop() async {
    if (!_auto || _busy || !mounted || _stt.isListening) return;
    try {
      await _stt.listen(
        localeId: _localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        onResult: (r) {
          setState(() => _heard = r.recognizedWords);
          if (r.finalResult) {
            _handle(r.recognizedWords);
          }
        },
      );
    } catch (_) {}
  }

  bool _isWake(String w) {
    return w.contains('fedo') ||
        RegExp(r'^[fpvh][eiaö][dt][oöu]$').hasMatch(w);
  }

  Future<void> _handle(String text) async {
    final words = text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty || !_isWake(words.first)) {
      return; // "Fedo" deyilməyibsə, səssizcə ötür
    }
    _busy = true;
    try {
      final rest = words.skip(1).toList();
      final joined = rest.join(' ');

      if (joined.contains('dayan') ||
          joined.contains('sus') ||
          joined.contains('stop')) {
        await _player.pause();
        setState(() => _status = 'Dayandırıldı');
      } else if (joined.contains('dəyiş') ||
          joined.contains('deyis') ||
          joined.contains('növbəti') ||
          joined.contains('next')) {
        if (_tracks.length > 1) {
          _index = (_index + 1) % _tracks.length;
          await _playCurrent();
        } else {
          setState(() => _status = 'Dəyişmək üçün başqa mahnı yoxdur');
        }
      } else if (joined == 'davam' || joined.contains('davam et')) {
        _player.play();
        setState(() => _status = 'Davam edir');
      } else {
        final query =
            rest.where((w) => !_fillers.contains(w)).join(' ').trim();
        if (query.isEmpty) {
          setState(() => _status = 'Mahnı adını da deyin');
        } else {
          setState(() => _status = 'Axtarılır: $query');
          _tracks = await searchTracks(query);
          _index = 0;
          if (_tracks.isEmpty) {
            setState(() => _status = 'Tapılmadı: $query');
          } else {
            await _playCurrent();
          }
        }
      }
    } finally {
      _busy = false;
      if (_auto) {
        Future.delayed(const Duration(milliseconds: 800), _listenLoop);
      }
    }
  }

  Future<void> _playCurrent() async {
    final t = _tracks[_index];
    setState(() => _status = 'Çalır: ${t.title} - ${t.artist}');
    try {
      await _player.setUrl(t.url);
      _player.play();
    } catch (e) {
      setState(() => _status = 'Çalmaq alınmadı');
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
                onTap: _toggleAuto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: _auto ? Colors.green : Colors.deepPurple,
                  child: Icon(_auto ? Icons.hearing : Icons.mic, size: 50),
                ),
              ),
              const SizedBox(height: 12),
              Text(_auto ? 'Daimi dinləmə AÇIQDIR' : 'Daimi dinləməni açmaq üçün basın'),
            ],
          ),
        ),
      ),
    );
  }
}
