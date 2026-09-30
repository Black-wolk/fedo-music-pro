
// lib/core/voice_engine.dart
class FedoVoiceEngine {
  bool isListening = false;
  double volume = 0.5;

  void onWakeWordDetected() {
    print("🎤 'Fedo' eşidildi! Audio Ducking aktivləşdirildi (%15 səs).");
  }

  void processCommand(String command) {
    if (command.contains("qoş")) {
      print("▶️ Mahnı axtarılır və çalınır: " + command);
    } else if (command.contains("səs ver")) {
      volume = (volume + 0.1).clamp(0.0, 1.0);
      print("🔊 Səs artırıldı: " + (volume * 100).toInt().toString() + "%");
    } else if (command.contains("bəsdir") || command.contains("dayan")) {
      print("⏸️ Əmr dayandırıldı.");
    }
  }
}
