import os

print("🎤 Real-vaxt Mahnı Sözləri (Lyrics/Karaoke) modulu əlavə edilir...")

lyrics_code = """
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
    List<String> lines = lrcContent.split('\\n');
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
"""

with open("lib/core/lyrics_service.dart", "w", encoding="utf-8") as f:
    f.write(lyrics_code)

# Main faylını yeni lyrics xidməti ilə yeniləyirik
updated_main = """
// lib/main.dart
import 'core/voice_engine.dart';
import 'core/audio_service.dart';
import 'core/equalizer_service.dart';
import 'core/lyrics_service.dart';

void main() async {
  print("==================================================");
  print("🔥 FEDO MUSIC PRO - REAL-TIME LYRICS MODULE TEST");
  print("==================================================");

  var lyricsService = LyricsService();

  // Test üçün LRC formatında sözlərin yüklənməsi
  String sampleLrc = '''
[00:00.00] Fedo Music Pro - Real-Time Karaoke
[00:03.50] Musiqi başlayır...
[00:10.00] Mahnının ilk sətri ekranımızda görünür
[00:15.00] Oxunan vaxta uyğun sözlər axıcı şəkildə dəyişir
''';

  lyricsService.loadLrcLyrics(sampleLrc);

  // Simulyasiya: 11-ci saniyədə hansı sətir görünür?
  String currentLine = lyricsService.getCurrentLyricLine(const Duration(seconds: 11));
  print("⏱️ [00:11.00] Ekranda görünən sətir: \"$currentLine\"");

  print("==================================================");
  print("🚀 REAL-VAXT LYRICS MODULU MÜVƏFFƏQİYYƏTLƏ İŞLƏYİR!");
  print("==================================================");
}
"""

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(updated_main)

print("✅ 'lib/core/lyrics_service.dart' uğurla yaradıldı!")
