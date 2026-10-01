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

  List<SongModel> _allSongs = [];
  List<SongModel> _filteredSongs = [];
  final Set<int> _favoriteSongIds = {};

  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    // Player dinləyiciləri (vaxt və dinamik yenilənmə üçün)
    _audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.durationStream.listen((d) {
      setState(() => _duration = d ?? Duration.zero);
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });
  }

  void _requestPermission() async {
    await Permission.storage.request();
    await Permission.audio.request();
    _loadSongs();
  }

  void _loadSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {
      _allSongs = songs;
      _filteredSongs = songs;
    });
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _allSongs;
      } else {
        _filteredSongs = _allSongs.where((song) {
          final title = song.title.toLowerCase();
          final artist = (song.artist ?? "").toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || artist.contains(search);
        }).toList();
      }
    });
  }

  void _playSongAtIndex(int index) async {
    if (index < 0 || index >= _filteredSongs.length) return;
    try {
      _currentIndex = index;
      await _audioPlayer.setFilePath(_filteredSongs[index].data);
      _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fayl oxunarkən xəta: $e")),
      );
    }
  }

  void _playNext() {
    if (_currentIndex < _filteredSongs.length - 1) {
      _playSongAtIndex(_currentIndex + 1);
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _playSongAtIndex(_currentIndex - 1);
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _toggleFavorite(int songId) {
    setState(() {
      if (_favoriteSongIds.contains(songId)) {
        _favoriteSongIds.remove(songId);
      } else {
        _favoriteSongIds.add(songId);
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongModel? currentSong = _currentIndex != -1 && _currentIndex < _filteredSongs.length
        ? _filteredSongs[_currentIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Mahnı və ya ifaçı axtar...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterSongs,
              )
            : const Text('Fedo Music Pro'),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredSongs = _allSongs;
                }
              });
            },
          ),
        ],
      ),
      body: _filteredSongs.isEmpty
          ? const Center(
              child: Text(
                'Mahnı tapılmadı.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                SongModel song = _filteredSongs[index];
                bool isFav = _favoriteSongIds.contains(song.id);
                bool isCurrent = _currentIndex == index;

                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.deepPurpleAccent : Colors.deepPurple.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCurrent ? Icons.music_note : Icons.audiotrack,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent ? Colors.deepPurpleAccent : Colors.white,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    song.artist ?? "Bilinməyən İfaçı",
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(song.id),
                      ),
                      IconButton(
                        icon: Icon(
                          isCurrent && _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.deepPurpleAccent,
                          size: 32,
                        ),
                        onPressed: () {
                          if (isCurrent) {
                            _togglePlayPause();
                          } else {
                            _playSongAtIndex(index);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: currentSong != null
          ? Container(
              height: 110,
              color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  // Progress Bar Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      activeColor: Colors.deepPurpleAccent,
                      inactiveColor: Colors.grey.shade800,
                      value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                      max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        Text(_formatDuration(_duration), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentSong.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              currentSong.artist ?? "Bilinməyən İfaçı",
                              maxLines: 1,
                              style: const TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 28),
                        onPressed: _playPrevious,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
                        onPressed: _playNext,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
