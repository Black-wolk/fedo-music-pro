
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
