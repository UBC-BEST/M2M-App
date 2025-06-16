// pages/stats_page.dart
import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            'Stats page',
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
