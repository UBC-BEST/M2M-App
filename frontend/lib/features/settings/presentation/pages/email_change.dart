import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

class EmailChange extends StatelessWidget {
  const EmailChange({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.emailSettingsTitle),
      ),
      body: Center(
        child: Text(localizations.placeholderComingSoon),
      ),
    );
  }
}
