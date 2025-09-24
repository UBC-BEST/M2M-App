import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            localizations.statsPagePlaceholder,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
