// main.dart
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/games_page.dart';
import 'pages/stats_page.dart';
import 'pages/settings_page.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Navigation(),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M2M Skeleton App'),
        backgroundColor: Colors.blue,
      ),
      body: <Widget>[
        const HomePage(),
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
            label: 'Progress',
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
