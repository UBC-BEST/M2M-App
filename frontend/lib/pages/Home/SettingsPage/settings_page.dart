import 'package:flutter/material.dart';
import 'settings_tile.dart';
import 'account_settings.dart';
import 'appearance_settings.dart';
import 'notifications_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white, // AppBar color
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calls the settingsButton widget to create buttons
            SettingsTile(
              icon: Icons.person_outline,
              title: 'Account Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettings()),
              ),
            ),

            SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsSettings()),
              ),
            ),

            SettingsTile(
              icon: Icons.remove_red_eye_outlined,
              title: 'Appearance',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppearanceSettings()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}