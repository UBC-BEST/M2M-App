import 'package:flutter/material.dart';
// import 'unity_game_launch.dart';
import '../home_page/home_page.dart';
import '../games_page/games_page.dart';
import '../stats_page/stats_page.dart';
import '../settings_page/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  List<Map<String, dynamic>> get games => [
        {'name': 'Pizza Game', 'onTap': null},
        {
          'name': 'Golf Game',
          'onTap': null,
        },
        {'name': 'Call of Duty', 'onTap': null},
        {'name': 'Spiderman', 'onTap': null},
        {'name': 'Valorant', 'onTap': null},
      ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          const HomePage(),
          GamesPage(games: games),
          const StatsPage(),
          const SettingsPage(),
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
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home, color: Colors.black),
            icon: const Icon(Icons.home_outlined),
            label: localizations.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.sports_esports, color: Colors.black),
            icon: const Icon(Icons.sports_esports_outlined),
            label: localizations.games,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.leaderboard, color: Colors.black),
            icon: const Icon(Icons.leaderboard_outlined),
            label: localizations.data,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings, color: Colors.black),
            icon: const Icon(Icons.settings_outlined),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }

  // // Navigate to Pizza Game
  // void _showPizzaGame() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             const FullScreenUnityGame(gameName: 'PizzaGame')),
  //   );
  // }

  // // Navigate to Golf Game (just an example)
  // // (josh) not completely sure how multiple games can be implemented, but im assuming
  // // we can find a way to implement multiple games by giving them some sort of identification like a "game name"
  // void _showGolfGame() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             const FullScreenUnityGame(gameName: 'GolfGame')),
  //   );
  // }
}
