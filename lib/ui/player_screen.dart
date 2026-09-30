
// lib/ui/player_screen.dart
// Fedo Music Pro - Əsas İdarəetmə və Pleyer Ekranı

import 'package:flutter/material.dart';

class FedoPlayerScreen extends StatefulWidget {
  const FedoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<FedoPlayerScreen> createState() => _FedoPlayerScreenState();
}

class _FedoPlayerScreenState extends State<FedoPlayerScreen> {
  bool isPlaying = false;
  double songProgress = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("FEDO MUSIC PRO", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.equalizer, color: Colors.cyanAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🎛️ Equalizer Pəncərəsi")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.directions_car, color: Colors.amber),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🚗 Avtomobil Rejimi Aktiv Edildi")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album Art Placeholder / Cover Image
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(Icons.music_note, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 32),

            // Track Info
            const Text(
              "Xəzri Meyxana / Mahnı 01",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Fedo Cloud Vault • Offlayn",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Progress Slider
            Slider(
              value: songProgress,
              activeColor: Colors.cyanAccent,
              inactiveColor: Colors.grey.shade800,
              onChanged: (value) {
                setState(() {
                  songProgress = value;
                });
              },
            ),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {},
                ),
                FloatingActionButton(
                  backgroundColor: Colors.cyanAccent,
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Voice Engine Status Indicator
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.mic, color: Colors.cyanAccent),
              label: const Text("🎙️ 'Fedo' deyərək əmr verin", style: TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
