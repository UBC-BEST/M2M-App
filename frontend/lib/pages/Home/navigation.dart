import 'package:flutter/material.dart';
//import 'unity_game_launch.dart';
import 'HomePage/home_page.dart';
import 'StatsPage/stats_page.dart';
import 'SettingsPage/settings_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  // List of games
  /* List<Map<String, dynamic>> get games => [
        {'name': 'Pizza Game', 'onTap': _showPizzaGame},
        {
          'name': 'Golf Game',
          'onTap': _showGolfGame
        }, //Just an example of future implmentation
        {'name': 'Call of Duty', 'onTap': null}, // Placeholder for future game
        {'name': 'Spiderman', 'onTap': null}, // Placeholder for future game
        {'name': 'Valorant', 'onTap': null}, // Placeholder for future game
      ];
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M2M Skeleton App'),
        backgroundColor: Colors.blue,
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: const <Widget>[
          HomePageAuth(),
            //GamesPage(games: games),
          StatsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue.shade100,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.black),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          /*NavigationDestination(
            selectedIcon: Icon(Icons.sports_esports, color: Colors.black),
            icon: Icon(Icons.sports_esports_outlined),
            label: 'Games', 
          ), */
          NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard, color: Colors.black),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Data',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, color: Colors.black),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

/*
  // Navigate to Pizza Game
  void _showPizzaGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const FullScreenUnityGame(gameName: 'PizzaGame')),
    );
  }

  // Navigate to Golf Game (just an example)
  // (josh) not completely sure how multiple games can be implemented, but im assuming
  // we can find a way to implement multiple games by giving them some sort of identification like a "game name"
  void _showGolfGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const FullScreenUnityGame(gameName: 'GolfGame')),
    );
  }
}
*/  }
