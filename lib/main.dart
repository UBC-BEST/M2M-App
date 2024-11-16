// main.dart
import 'package:flutter/material.dart';

import 'pages/Intro/intro1_page.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black), // Set a global focus color
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.blue, // Highlighted text background color
          cursorColor: Colors.blue, // Cursor color (can be customized)
          selectionHandleColor: Colors.blue, // Selection handle color
        ),
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue),
      ),
      home: const NavigationScreen(),
      // theme: ThemeData(useMaterial3: true),
      // home: const Navigation(),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: IntroPage1(),
      ),
    );
  }
}
