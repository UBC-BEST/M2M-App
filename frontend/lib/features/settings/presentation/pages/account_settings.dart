import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';
import '../widgets/settings_tile.dart';
import 'email_change.dart';
import 'name_change.dart';
import 'password_change.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    const placeholderName = 'Jane Doe';
    const placeholderEmail = 'jane123@gmail.com';
    const placeholderPassword = '********';

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
              subtitle: placeholderName,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NameChange()),
              ),
            ),
            SettingsTile(
              icon: Icons.email_outlined,
              title: localizations.email,
              subtitle: placeholderEmail,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailChange()),
              ),
            ),
            SettingsTile(
              icon: Icons.lock_outline,
              title: localizations.password,
              subtitle: placeholderPassword,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasswordChange()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
