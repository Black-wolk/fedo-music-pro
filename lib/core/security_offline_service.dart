
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
