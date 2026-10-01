class LyricsService {
  // Mahnının adına uyğun sözləri gətirən modul
  Future<String> fetchLyrics(String songTitle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Fedo Music Pro\n\nOxunur: $songTitle\n\n[00:10.00] Mahnı sözləri yüklənir...\n[00:20.00] Fedo Music Pro yüksək səs keyfiyyəti ilə çalışır.";
  }
}
