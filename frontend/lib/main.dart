import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/Intro/intro1_page.dart';
import 'pages/Login/login_page.dart';
import 'pages/Home/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final prefs = await SharedPreferences.getInstance();

  final bool isFirstLaunch = prefs.getBool('hasLaunched') != true;
  final bool isLoggedIn = prefs.getString('accessToken') != null;

  if (isFirstLaunch) {
    await prefs.setBool('hasLaunched', true);
  }

  runApp(MyApp(
    showIntro: isFirstLaunch,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  final bool isLoggedIn;

  const MyApp({super.key, required this.showIntro, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Widget initialPage;

    if (showIntro) {
      initialPage = const IntroPage1();
    } else if (!isLoggedIn) {
      initialPage = const LoginPage();
    } else {
      initialPage = const Navigation();
    }

    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.blue,
          cursorColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue),
      ),
      home: initialPage,
    );
  }
}
