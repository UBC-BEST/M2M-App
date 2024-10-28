import 'package:flutter/material.dart';

/// Flutter code sample for MainApp

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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
            label: ('Home'),
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.sports_esports, color: Colors.black),
              icon: Icon(Icons.sports_esports_outlined),
              label: 'Games'),
          NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard, color: Colors.black),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Progress',
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.leaderboard, color: Colors.black),
              icon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Landing Page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Notifications page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Boot game here',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Messages page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Display stats here',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        //Settings Page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Display Settings Here',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
      appBar: AppBar(
        title: const Text('M2M Skeleton App'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
