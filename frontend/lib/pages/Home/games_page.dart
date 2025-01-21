import 'package:flutter/material.dart';

class GamesPage extends StatelessWidget {
  final List<Map<String, dynamic>> games;

  const GamesPage({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    // Simple list that shows all of the games on a horizontal scrolling axis
    // It takes game information passed by landing.dart to name the tiles
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Games',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16), // Space between title and list
            // Horizontally scrollable list
            SizedBox(
              height: 150, // Square tile size
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return GestureDetector(
                    onTap: game['onTap'] != null ? () => game['onTap']() : null,
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          game['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
