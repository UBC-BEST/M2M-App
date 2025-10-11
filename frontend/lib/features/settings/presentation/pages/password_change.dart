import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

class PasswordChange extends StatelessWidget {
  const PasswordChange({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.passwordSettingsTitle),
      ),
      body: Center(
        child: Text(localizations.placeholderComingSoon),
      ),
    );
  }
}
