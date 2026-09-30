
// lib/core/lyrics_service.dart
import 'dart:async';

class LyricLine {
  final Duration timeStamp;
  final String text;

  LyricLine({required this.timeStamp, required this.text});
}

class LyricsService {
  List<LyricLine> _currentLyrics = [];
  int _currentIndex = 0;

  // 1. LRC (Time-synced lyrics) mətni yükləmək və emal etmək
  void loadLrcLyrics(String lrcContent) {
    _currentLyrics.clear();
    _currentIndex = 0;

    // LRC nümunə mətni sətir-sətir ayrılır
    List<String> lines = lrcContent.split('\n');
    for (var line in lines) {
      if (line.contains("[") && line.contains("]")) {
        try {
          var timePart = line.substring(line.indexOf("[") + 1, line.indexOf("]"));
          var textPart = line.substring(line.indexOf("]") + 1).trim();

          var parts = timePart.split(":");
          var minutes = int.parse(parts[0]);
          var seconds = double.parse(parts[1]);

          var totalMs = (minutes * 60 * 1000) + (seconds * 1000).toInt();
          _currentLyrics.add(LyricLine(
            timeStamp: Duration(milliseconds: totalMs),
            text: textPart,
          ));
        } catch (e) {
          // Başlıq sətirlərini (örənək: [artist: ...]) ötürük
        }
      }
    }
    print("📜 Mahnı sözləri yükləndi. Ümumi sətir sayı: ${_currentLyrics.length}");
  }

  // 2. Cari vaxta uyğun aktiv sətiri tapmaq
  String getCurrentLyricLine(Duration position) {
    if (_currentLyrics.isEmpty) return "Mahnı sözləri mövcud deyil.";

    for (int i = 0; i < _currentLyrics.length; i++) {
      if (position >= _currentLyrics[i].timeStamp) {
        if (i == _currentLyrics.length - 1 || position < _currentLyrics[i + 1].timeStamp) {
          _currentIndex = i;
          return _currentLyrics[i].text;
        }
      }
    }
    return _currentLyrics.first.text;
  }
}
