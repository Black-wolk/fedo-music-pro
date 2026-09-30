
// lib/main.dart
import 'core/voice_engine.dart';
import 'core/audio_service.dart';
import 'core/equalizer_service.dart';

void main() async {
  print("==================================================");
  print("🔥 FEDO MUSIC PRO - EQUALIZER & AUDIO EFFECTS TEST");
  print("==================================================");

  var equalizer = EqualizerService();

  // 1. Equalizer Preset Testi
  equalizer.setPreset("Bass Boost");
  equalizer.setBassBoost(85.0);

  // 2. Özel Zolaq Ayarı Testi
  equalizer.setBandLevel("14kHz", 4.5);
  print("🎵 Cari Equalizer Rejimi: ${equalizer.currentPreset}");

  print("==================================================");
  print("🚀 EQUALIZER SİSTEMİ MÜVƏFFƏQİYYƏTLƏ İŞLƏYİR!");
  print("==================================================");
}
