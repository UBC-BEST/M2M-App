// pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
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
    );
  }
}
