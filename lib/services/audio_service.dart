import 'package:just_audio/just_audio.dart';

class AudioEngineService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get player => _audioPlayer;

  Future<void> playAudio(String path) async {
    try {
      await _audioPlayer.setFilePath(path);
      await _audioPlayer.play();
    } catch (e) {
      print("Audio Engine Error: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
