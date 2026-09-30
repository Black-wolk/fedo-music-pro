
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
