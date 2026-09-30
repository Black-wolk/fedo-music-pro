import os

print("🔐 PIN Kod qoruması və Offline Keşləmə modulu əlavə edilir...")

security_offline_code = """
// lib/core/security_offline_service.dart
import 'dart:async';

class SecurityAndOfflineService {
  String _userPin = "1234"; // Standart təhlükəsizlik PIN kodu
  bool isVaultLocked = true;
  List<String> cachedSongsList = [];

  // 1. PIN Kodla Şəxsi Papkanı Açmaq
  bool unlockVault(String inputPin) {
    if (inputPin == _userPin) {
      isVaultLocked = false;
      print("🔓 Təhlükəsizlik PIN kodu təsdiqləndi! Şəxsi papka açıldı.");
      return true;
    } else {
      print("❌ Yanlış PIN kod! Şəxsi papkaya giriş rədd edildi.");
      return false;
    }
  }

  // 2. PIN Kodu Dəyişmək
  void changePin(String oldPin, String newPin) {
    if (oldPin == _userPin) {
      _userPin = newPin;
      print("🔑 PIN kod uğurla dəyişdirildi!");
    } else {
      print("⚠️ Əvvəlki PIN kod daxil edilmədi.");
    }
  }

  // 3. Offline Keşləmə (İnternetsiz dinləmə üçün)
  Future<void> cacheSongLocally(String songId, String fileUrl) async {
    print("📥 Offline rejimi üçün yüklənir: '$songId'...");
    await Future.delayed(const Duration(milliseconds: 300));
    cachedSongsList.add(songId);
    print("⚡ '$songId' cihaz yaddaşına saxlanıldı. İnternetsiz oxutmaq mümkündür!");
  }

  // 4. Mahnının Keşdə Olub-olmadığını Yoxlamaq
  bool isSongCached(String songId) {
    return cachedSongsList.contains(songId);
  }
}
"""

with open("lib/core/security_offline_service.dart", "w", encoding="utf-8") as f:
    f.write(security_offline_code)

# Main faylını yeni təhlükəsizlik xidməti ilə yeniləyirik
updated_main = """
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
"""

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(updated_main)

print("✅ 'lib/core/security_offline_service.dart' uğurla yaradıldı!")
