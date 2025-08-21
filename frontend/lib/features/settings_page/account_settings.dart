import 'package:flutter/material.dart';
import 'settings_tile.dart';
import 'name_change.dart';
import 'email_change.dart';
import 'password_change.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for user data, this should be replaced with actual user data from the database
    String currentName = "Jane Doe"; // Placeholder for current name
    String currentEmail = "jane123@gmail.com"; // Placeholder for current email
    String currentPassword = "********"; // Placeholder for current password

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.accountSettings),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.badge_outlined,
              title: localizations.nameAndUsername,
              subtitle: currentName,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NameChange()),
              ),
            ),
            SettingsTile(
              icon: Icons.email_outlined,
              title: localizations.email,
              subtitle: currentEmail, // Display current email
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailChange()),
              ),
            ),
            SettingsTile(
              icon: Icons.lock_outline,
              title: localizations.password,
              subtitle: currentPassword,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordChange()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
