import os

print("📦 Məlumat bazası, Pley-listlər və ID sistemi modelləri yaradılır...")

db_service_code = """
// lib/core/database_service.dart
import 'dart0:async';

class SongModel {
  final String id;
  final String title;
  final String artist;
  final String fileUrl;
  final bool isOfflineCached;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.fileUrl,
    this.isOfflineCached = false,
  });
}

class UserProfile {
  final String userId; // Məsələn: FEDO-83921
  final String name;
  bool isPremium;
  double cloudStorageLimitMb;
  double usedStorageMb;
  List<SongModel> favorites;
  Map<String, List<SongModel>> customPlaylists;

  UserProfile({
    required this.userId,
    required this.name,
    this.isPremium = false,
    this.cloudStorageLimitMb = 500.0, // Pulsuz istifadəçi üçün 500MB
    this.usedStorageMb = 0.0,
    required this.favorites,
    required this.customPlaylists,
  });
}

class FedoDatabaseService {
  // Şəxsi Yaddaşa Mahnı/Video Yükləmək
  void uploadToCloud(UserProfile user, SongModel song, double fileSizeMb) {
    if (user.usedStorageMb + fileSizeMb > user.cloudStorageLimitMb) {
      print("⚠️ Xəbərdarlıq: ${user.userId} üçün Yaddaş dolub! 1 AZN Premium ilə 10 GB-a qaldırın.");
      return;
    }
    user.usedStorageMb += fileSizeMb;
    print("☁️ '${song.title}' mahnısı ${user.userId} hesabının şəxsi bulud yaddaşına yazıldı.");
    print("📊 İşlənən Yaddaş: ${user.usedStorageMb.toStringAsFixed(1)} MB / ${user.cloudStorageLimitMb.toStringAsFixed(1)} MB");
  }

  // Xüsusi Papka (Pley-list) Yaradılması
  void createPlaylist(UserProfile user, String folderName) {
    if (!user.customPlaylists.containsKey(folderName)) {
      user.customPlaylists[folderName] = [];
      print("📁 '${folderName}' adlı şəxsi papka yaradıldı.");
    }
  }

  // Papkaya Mahnı Əlavə Etmək
  void addToFolder(UserProfile user, String folderName, SongModel song) {
    if (user.customPlaylists.containsKey(folderName)) {
      user.customPlaylists[folderName]!.add(song);
      print("➕ '${song.title}' mahnısı '${folderName}' papkasına əlavə olundu.");
    }
  }
}
"""

with open("lib/core/database_service.dart", "w", encoding="utf-8") as f:
    f.write(db_service_code)

# Main faylını tam kompleks sistem kimi yeniləyirik
updated_main = """
// lib/main.dart
import 'core/voice_engine.dart';
import 'core/audio_service.dart';
import 'core/database_service.dart';

void main() async {
  print("==================================================");
  print("🔥 FEDO MUSIC PRO - FULL SYSTEM TEST (TERMUX)");
  print("==================================================");

  var voice = FedoVoiceEngine();
  var audio = FedoAudioService();
  var db = FedoDatabaseService();

  // 1. İstifadəçi Profili yaradılır (ID sistemi ilə)
  var currentUser = UserProfile(
    userId: "FEDO-83921",
    name: "Bayramov Ferdi",
    favorites: [],
    customPlaylists: {},
  );

  print("👤 İstifadəçi Giriş Etdi: ID -> ${currentUser.userId}");

  // 2. Səsli Oyanma ("Fedo")
  voice.onWakeWordDetected();

  // 3. 3-Saniyəlik Axtarış Və Çalma
  String searchRes = await audio.searchAndPlay("Fedo Üzeyir Mehdizadə mahnıları qoş");
  print(searchRes);

  // 4. Mahnını Şəxsi Yaddaşa və Papkaya Yükləmək
  var sampleSong = SongModel(
    id: "S-101",
    title: "Üzeyir Mehdizadə - Album 2026",
    artist: "Üzeyir Mehdizadə",
    fileUrl: "https://cloud.fedomusic.az/songs/101.mp3",
  );

  db.createPlaylist(currentUser, "Maşın üçün");
  db.uploadToCloud(currentUser, sampleSong, 8.5); // 8.5 MB
  db.addToFolder(currentUser, "Maşın üçün", sampleSong);

  // 5. Səsli Əmrlə Səsin Düzenlənməsi
  voice.processCommand("Fedo biraz səs ver");
  audio.adjustVolume("increase", 0.6);
  voice.processCommand("Bəsdir");

  print("==================================================");
  print("🚀 BÜTÜN MODULLAR (SƏS + AUDIO + DB + ID) UĞURLA BİR BİRİNƏ BAĞLANDI!");
  print("==================================================");
}
"""

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(updated_main)

print("✅ 'lib/core/database_service.dart' uğurla yaradıldı və sistemi tamamladı!")
