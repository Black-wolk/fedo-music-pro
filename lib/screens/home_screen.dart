import 'dart:async';
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
  Timer? _sleepTimer;
  int _remainingMinutes = 0;

  @override
  void initState() {
    super.initState();
    _requestPermission();

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

  void _setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    setState(() {
      _remainingMinutes = minutes;
    });

    if (minutes > 0) {
      _sleepTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        setState(() {
          _remainingMinutes--;
        });
        if (_remainingMinutes <= 0) {
          _audioPlayer.pause();
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Yuxu taymeri tamamlandı, musiqi saxlanıldı.")),
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Taymer $minutes dəqiqəyə quruldu.")),
      );
    }
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1C2C),
        title: const Text("Yuxu Taymeri", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [15, 30, 45, 60].map((mins) {
            return ListTile(
              title: Text("$mins Dəqiqə", style: const TextStyle(color: Colors.white70)),
              onTap: () {
                _setSleepTimer(mins);
                Navigator.pop(context);
              },
            );
          }).toList()
            ..add(
              ListTile(
                title: const Text("Taymeri Söndür", style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  _setSleepTimer(0);
                  Navigator.pop(context);
                },
              ),
            ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongModel? currentSong = _currentIndex != -1 && _currentIndex < _filteredSongs.length
        ? _filteredSongs[_currentIndex]
        : null;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Mahnı və ya ifaçı axtar...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                  onChanged: _filterSongs,
                )
              : const Text(
                  'Fedo Music Pro',
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
          centerTitle: !_isSearching,
          actions: [
            IconButton(
              icon: Icon(
                _remainingMinutes > 0 ? Icons.timer : Icons.timer_outlined,
                color: _remainingMinutes > 0 ? Colors.cyanAccent : Colors.white,
              ),
              onPressed: _showTimerDialog,
            ),
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
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
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  SongModel song = _filteredSongs[index];
                  bool isFav = _favoriteSongIds.contains(song.id);
                  bool isCurrent = _currentIndex == index;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepPurple, Colors.purpleAccent],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isCurrent ? Icons.equalizer : Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        song.artist ?? "Bilinməyən İfaçı",
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white60,
                            ),
                            onPressed: () => _toggleFavorite(song.id),
                          ),
                          IconButton(
                            icon: Icon(
                              isCurrent && _isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.cyanAccent,
                              size: 34,
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
                    ),
                  );
                },
              ),
        bottomNavigationBar: currentSong != null
            ? Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF181528).withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        trackHeight: 3,
                        activeTrackColor: Colors.cyanAccent,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.cyanAccent,
                      ),
                      child: Slider(
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
                          Text(_formatDuration(_position), style: const TextStyle(color: Colors.white60, fontSize: 10)),
                          Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white60, fontSize: 10)),
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
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                currentSong.artist ?? "Bilinməyən İfaçı",
                                maxLines: 1,
                                style: const TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 30),
                          onPressed: _playPrevious,
                        ),
                        IconButton(
                          icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.cyanAccent, size: 40),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 30),
                          onPressed: _playNext,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
