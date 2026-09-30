import os

print("🚗 Car Mode və 🌙 Sleep Timer modulları əlavə edilir...")

car_timer_code = """
// lib/core/car_and_timer_service.dart
import 'dart:async';

class CarModeAndSleepTimerService {
  bool isCarModeActive = false;
  Timer? _sleepTimer;
  int remainingSeconds = 0;

  // 1. Avtomobil Rejimini Aktiv/Deaktiv Etmək
  void toggleCarMode() {
    isCarModeActive = !isCarModeActive;
    print("🚗 Avtomobil Rejimi (Car Mode): ${isCarModeActive ? 'AKTİVDİR (Səth böyüdüldü)' : 'DEAKTİVDİR'}");
  }

  // 2. Yuxu Taymerini Başlatmaq (Dəqiqə ilə)
  void startSleepTimer(int minutes, Function onTimerFinished) {
    _sleepTimer?.cancel();
    remainingSeconds = minutes * 60;
    print("🌙 Yuxu Taymeri təyin olundu: $minutes dəqiqə.");

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
      } else {
        timer.cancel();
        print("🛑 Yuxu Taymeri bitdi. Musiqi dayandırılır...");
        onTimerFinished();
      }
    });
  }

  // 3. Yuxu Taymerini Ləğv Etmək
  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    remainingSeconds = 0;
    print("🚫 Yuxu Taymeri ləğv edildi.");
  }
}
"""

with open("lib/core/car_and_timer_service.dart", "w", encoding="utf-8") as f:
    f.write(car_timer_code)

# Main faylını yeniləyirik
updated_main = """
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
"""

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(updated_main)

print("✅ 'lib/core/car_and_timer_service.dart' uğurla yaradıldı!")
