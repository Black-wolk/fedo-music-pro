
// lib/core/stream_adapter.dart
import 'dart:async';

class StreamResult {
  final String title;
  final String streamUrl;
  final String thumbnailUrl;
  final bool isVideo;

  StreamResult({
    required this.title,
    required this.streamUrl,
    required this.thumbnailUrl,
    this.isVideo = false,
  });
}

class FedoStreamAdapter {
  // Ultra-fast stream link parser (Max 3 saniyə reaksiyası üçün)
  Future<StreamResult> fetchAudioStream(String query) async {
    print("🌐 Canlı audio linki çəkilir: '$query'...");
    
    // Şəbəkə sorğusunun simulyasiyası (0.4 san)
    await Future.delayed(const Duration(milliseconds: 400));

    return StreamResult(
      title: query,
      streamUrl: "https://stream.fedomusic.az/live/stream.mp3",
      thumbnailUrl: "https://fedomusic.az/covers/default.jpg",
      isVideo: false,
    );
  }
}
