import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

import '../../games/domain/game_item.dart';
import '../../games/presentation/games_page.dart';
import '../../home/presentation/home_page.dart';
import '../../settings/presentation/pages/settings_page.dart';
import '../../stats/presentation/stats_page.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final games = _buildGames(localizations);

    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
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
            _currentPageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue.shade100,
        selectedIndex: _currentPageIndex,
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

  List<GameItem> _buildGames(AppLocalizations localizations) {
    return [
      GameItem(name: localizations.gamePizza),
      GameItem(name: localizations.gameGolf),
      GameItem(name: localizations.gameCallOfDuty),
      GameItem(name: localizations.gameSpiderman),
      GameItem(name: localizations.gameValorant),
    ];
  }
}
