import os

print("🎤 Səsli əmrlər bazası genişləndirilir...")

expanded_voice_code = """
// lib/core/voice_engine.dart
class FedoVoiceEngine {
  bool isListening = false;
  double volume = 0.5;
  int currentTrackIndex = 0;
  bool isShuffle = false;
  bool isRepeat = false;

  void onWakeWordDetected() {
    print("🎤 'Fedo' eşidildi! Səs %15 seviyyəsinə endirildi (Audio Ducking).");
  }

  void processCommand(String command) {
    String lowerCmd = command.toLowerCase();

    // 1. Oxutma Və Axtarış Əmrləri
    if (lowerCmd.contains("qoş") || lowerCmd.contains("oxut")) {
      print("▶️ Əmr icra olunur: " + command);
    } 
    // 2. Dayandırma Və Pauza
    else if (lowerCmd.contains("sakid ol") || lowerCmd.contains("bəsdir") || lowerCmd.contains("dayan") || lowerCmd.contains("saxla")) {
      print("⏸️ Oxutma dayandırıldı.");
    } 
    // 3. Növbəti Və Əvvəlki Mahnı
    else if (lowerCmd.contains("növbəti") || lowerCmd.contains("çevir") || lowerCmd.contains("sonrakı")) {
      currentTrackIndex++;
      print("⏭️ Növbəti mahnıya keçildi. İndeks: ${currentTrackIndex}");
    } else if (lowerCmd.contains("əvvəlki") || lowerCmd.contains("qayıt")) {
      if (currentTrackIndex > 0) currentTrackIndex--;
      print("⏮️ Əvvəlki mahnıya keçildi. İndeks: ${currentTrackIndex}");
    } 
    // 4. Səs Səviyyəsi İdarəsi
    else if (lowerCmd.contains("səs artır") || lowerCmd.contains("biraz səs ver")) {
      volume = (volume + 0.15).clamp(0.0, 1.0);
      print("🔊 Səs artırıldı: ${(volume * 100).toInt()}%");
    } else if (lowerCmd.contains("səs azalt") || lowerCmd.contains("səsi al")) {
      volume = (volume - 0.15).clamp(0.0, 1.0);
      print("🔉 Səs azaldıldı: ${(volume * 100).toInt()}%");
    } 
    // 5. Rejim Əmrləri (Qarışıq / Təkrar)
    else if (lowerCmd.contains("qarışıq") || lowerCmd.contains("qarışdır")) {
      isShuffle = !isShuffle;
      print("🔀 Qarışıq oxutma rejimi: ${isShuffle ? 'Aktiv' : 'Deaktiv'}");
    } else if (lowerCmd.contains("təkrar et") || lowerCmd.contains("dəfələrlə")) {
      isRepeat = !isRepeat;
      print("🔂 Təkrar rejimi: ${isRepeat ? 'Aktiv' : 'Deaktiv'}");
    } 
    // 6. Papka Və Pley-list Keçidi
    else if (lowerCmd.contains("papkaya keç") || lowerCmd.contains("pleylist")) {
      print("📁 İstenilən papkaya keçid edilir: " + command);
    } else {
      print("❓ Anlaşılmayan əmr: '$command'. Yenidən cəhd edin.");
    }
  }
}
"""

with open("lib/core/voice_engine.dart", "w", encoding="utf-8") as f:
    f.write(expanded_voice_code)

print("✅ Səsli əmrlər modulu genişləndirildi!")
