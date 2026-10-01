import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fedo_music_pro/services/audio_service.dart';
import 'package:fedo_music_pro/services/audio_query_service.dart';
import 'package:fedo_music_pro/services/equalizer_service.dart';
import 'package:fedo_music_pro/services/lyrics_service.dart';

class FedoPlayerScreen extends StatefulWidget {
  const FedoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<FedoPlayerScreen> createState() => _FedoPlayerScreenState();
}

class _FedoPlayerScreenState extends State<FedoPlayerScreen> {
  final AudioEngineService _audioEngine = AudioEngineService();
  final LocalAudioQueryService _audioQueryService = LocalAudioQueryService();
  late EqualizerService _equalizerService;
  final LyricsService _lyricsService = LyricsService();

  List<SongModel> _songs = [];
  bool _isLoading = true;
  SongModel? _currentSong;
  String _currentLyrics = "Mahnı seçilməyib";

  @override
  void initState() {
    super.initState();
    _equalizerService = EqualizerService(_audioEngine.player);
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    List<SongModel> songs = await _audioQueryService.fetchLocalSongs();
    setState(() {
      _songs = songs;
      _isLoading = false;
    });
  }

  void _playSong(SongModel song) async {
    setState(() {
      _currentSong = song;
      _currentLyrics = "Mahnı sözləri axtarılır...";
    });
    if (song.data.isNotEmpty) {
      await _audioEngine.playAudio(song.data);
      String lyrics = await _lyricsService.fetchLyrics(song.title);
      setState(() {
        _currentLyrics = lyrics;
      });
    }
  }

  @override
  void dispose() {
    _audioEngine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(_currentSong != null ? _currentSong!.title : 'Fedo Music Pro'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Column(
              children: [
                Expanded(
                  child: _songs.isEmpty
                      ? const Center(child: Text("Musiqi faylı tapılmadı", style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: _songs.length,
                          itemBuilder: (context, index) {
                            final song = _songs[index];
                            return ListTile(
                              leading: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.deepPurple, size: 35),
                              ),
                              title: Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                song.artist ?? "Bilinməyən İfaçı",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              onTap: () => _playSong(song),
                            );
                          },
                        ),
                ),
                if (_currentSong != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.deepPurple.withOpacity(0.2),
                    child: Column(
                      children: [
                        Text(
                          _currentLyrics,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
