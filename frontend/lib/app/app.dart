import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';
import '../features/auth/presentation/login/login_page.dart';
import '../features/navigation/presentation/navigation_shell.dart';
import '../features/onboarding/presentation/intro/onboarding_flow.dart';
import 'startup/app_launch_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.launchState});

  final AppLaunchState launchState;

  @override
  Widget build(BuildContext context) {
    final initialPage = _resolveInitialPage();

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
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: initialPage,
    );
  }

  Widget _resolveInitialPage() {
    if (launchState.showOnboarding) {
      return const OnboardingFlow();
    }

    if (launchState.isLoggedIn) {
      return const NavigationShell();
    }

    return const LoginPage();
  }
}
