import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fedo Music Pro'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
            title: Text('Musiqi ${index + 1}'),
            subtitle: const Text('Müğənni adı'),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {},
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFF1E1E1E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.skip_previous, size: 36),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurple,
              child: IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {},
              ),
            ),
            const Icon(Icons.skip_next, size: 36),
          ],
        ),
      ),
    );
  }
}
