import 'package:flutter/material.dart';

import 'home_page.dart';
import 'games_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => Landing();
}

class Landing extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M2M Skeleton App'),
        backgroundColor: Colors.blue,
      ),
      body: <Widget>[
        const HomePageAuth(),
        const GamesPage(),
        const StatsPage(),
        const SettingsPage(),
      ][currentPageIndex],
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
          NavigationDestination(
            selectedIcon: Icon(Icons.sports_esports, color: Colors.black),
            icon: Icon(Icons.sports_esports_outlined),
            label: 'Games',
          ),
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
}
