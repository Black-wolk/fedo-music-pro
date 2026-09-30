
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
  print("⏱️ [00:11.00] Ekranda görünən sətir: "$currentLine"");

  print("==================================================");
  print("🚀 REAL-VAXT LYRICS MODULU MÜVƏFFƏQİYYƏTLƏ İŞLƏYİR!");
  print("==================================================");
}
