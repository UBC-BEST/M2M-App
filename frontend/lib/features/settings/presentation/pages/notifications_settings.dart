import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notifications),
      ),
      body: Center(
        child: Text(localizations.placeholderComingSoon),
      ),
    );
  }
}
