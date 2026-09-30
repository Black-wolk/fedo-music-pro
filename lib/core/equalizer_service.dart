
// lib/core/equalizer_service.dart
import 'dart:async';

class EqualizerService {
  bool isEnabled = true;
  String currentPreset = "Normal";
  
  // 5-Zolaqlı Equalizer Seviyyələri (Hz: -10 ilə +10 arası)
  Map<String, double> bands = {
    "60Hz": 0.0,   // Bass
    "230Hz": 0.0,  // Low-Mid
    "910Hz": 0.0,  // Mid
    "3.6kHz": 0.0, // High-Mid
    "14kHz": 0.0,  // Treble
  };

  double bassBoostLevel = 0.0; // 0.0 - 100.0%
  double virtualizer3D = 0.0;  // 3D Səs Effekti (0.0 - 100.0%)

  // Öncedən təyin olunmuş rejimlər (Presets)
  final Map<String, Map<String, double>> presets = {
    "Normal": {"60Hz": 0.0, "230Hz": 0.0, "910Hz": 0.0, "3.6kHz": 0.0, "14kHz": 0.0},
    "Bass Boost": {"60Hz": 8.0, "230Hz": 5.0, "910Hz": 1.0, "3.6kHz": 0.0, "14kHz": -1.0},
    "Pop": {"60Hz": -1.0, "230Hz": 2.0, "910Hz": 5.0, "3.6kHz": 3.0, "14kHz": -2.0},
    "Rock": {"60Hz": 5.0, "230Hz": 3.0, "910Hz": -1.0, "3.6kHz": 3.0, "14kHz": 6.0},
    "Vocal": {"60Hz": -3.0, "230Hz": 1.0, "910Hz": 6.0, "3.6kHz": 4.0, "14kHz": 1.0},
  };

  // Preset tətbiq etmək
  void setPreset(String name) {
    if (presets.containsKey(name)) {
      currentPreset = name;
      bands = Map.from(presets[name]!);
      print("🎛️ Equalizer Rejimi Dəyişdirildi: '$name'");
    } else {
      print("⚠️ Naməlum preset: $name");
    }
  }

  // Bitişik zolağı əllə tənzimləmək
  void setBandLevel(String band, double level) {
    if (bands.containsKey(band)) {
      bands[band] = level;
      currentPreset = "Custom";
      print("🎚️ $band zolağı $level dB olaraq tənzimləndi.");
    }
  }

  // Bass Boost tənzimlənməsi
  void setBassBoost(double level) {
    bassBoostLevel = level;
    print("🔊 Bass Boost: $level%");
  }
}
