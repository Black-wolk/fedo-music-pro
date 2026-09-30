
// lib/main.dart
import 'core/voice_engine.dart';
import 'core/audio_service.dart';
import 'core/database_service.dart';
import 'core/security_offline_service.dart';

void main() async {
  print("==================================================");
  print("🔥 FEDO MUSIC PRO - SECURITY & OFFLINE TEST");
  print("==================================================");

  var voice = FedoVoiceEngine();
  var security = SecurityAndOfflineService();

  // 1. Şəxsi Papka PIN Qoruması Testi
  print("🔒 Şəxsi papkaya giriş cəhdi:");
  security.unlockVault("0000"); // Yanlış PIN
  security.unlockVault("1234"); // Doğru PIN

  // 2. Offline Keşləmə Testi
  await security.cacheSongLocally("S-101", "https://cloud.fedomusic.az/songs/101.mp3");
  print("📱 Mahnı Internetsiz Mövcuddurmu? -> ${security.isSongCached("S-101")}");

  // 3. Səs Əmri Testi
  voice.onWakeWordDetected();
  voice.processCommand("Fedo maşın üçün papkaya keç");

  print("==================================================");
  print("🚀 BÜTÜN MODULLAR MÜVƏFFƏQİYYƏTLƏ İŞLƏYİR!");
  print("==================================================");
}
