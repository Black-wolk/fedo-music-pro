import 'package:just_audio/just_audio.dart';

class EqualizerService {
  final AudioPlayer _player;

  EqualizerService(this._player);

  // Bas Gücləndirmə / Pitch tənzimlənməsi
  Future<void> setPitch(double pitch) async {
    await _player.setPitch(pitch);
  }

  // Oxutma Sürəti Tənzimlənməsi (0.5x - 2.0x)
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }
}
