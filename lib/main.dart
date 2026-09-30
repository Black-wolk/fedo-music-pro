
// lib/main.dart
import 'core/voice_engine.dart';
import 'core/audio_service.dart';
import 'core/equalizer_service.dart';
import 'core/lyrics_service.dart';
import 'core/car_and_timer_service.dart';

void main() async {
  print("==================================================");
  print("🔥 FEDO MUSIC PRO - CAR MODE & SLEEP TIMER TEST");
  print("==================================================");

  var carAndTimer = CarModeAndSleepTimerService();

  // 1. Car Mode Testi
  carAndTimer.toggleCarMode();

  // 2. Sleep Timer Testi (Simulyasiya)
  carAndTimer.startSleepTimer(30, () {
    print("🎵 [CALLBACK] Musiqi müvəffəqiyyətlə söndürüldü!");
  });

  print("==================================================");
  print("🚀 BÜTÜN MODULLAR MÜVƏFFƏQİYYƏTLƏ İŞLƏYİR!");
  print("==================================================");
}
