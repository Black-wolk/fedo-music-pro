
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
