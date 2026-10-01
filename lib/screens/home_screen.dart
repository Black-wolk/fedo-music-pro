import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  SongModel? _currentSong;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    await Permission.storage.request();
    await Permission.audio.request();
    setState(() {});
  }

  void _playSong(SongModel song) async {
    try {
      await _audioPlayer.setFilePath(song.data);
      _audioPlayer.play();
      setState(() {
        _currentSong = song;
        _isPlaying = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fayl oxunarkən xəta yarandı: $e")),
      );
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
        title: const Text('Fedo Music Pro (Offline)'),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text(
                'Yaddaşda heç bir musiqi faylı tapılmadı.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              SongModel song = item.data![index];
              return ListTile(
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
                ),
                title: Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist ?? "Bilinməyən İfaçı",
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: Icon(
                    _currentSong?.id == song.id && _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.deepPurpleAccent,
                    size: 32,
                  ),
                  onPressed: () {
                    if (_currentSong?.id == song.id) {
                      _togglePlayPause();
                    } else {
                      _playSong(song);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _currentSong != null
          ? Container(
              height: 75,
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentSong!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _currentSong!.artist ?? "Bilinməyən İfaçı",
                          maxLines: 1,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 36,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
