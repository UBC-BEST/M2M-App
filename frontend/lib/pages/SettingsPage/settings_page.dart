import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/login_page.dart';
import 'settings_tile.dart';
import 'account_settings.dart';
import 'appearance_settings.dart';
import 'notifications_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _useFaceID = false;

  @override
  void initState() {
    super.initState();
    _loadFaceIDPreference();
  }

  Future<void> _loadFaceIDPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useFaceID = prefs.getBool('useFaceID') ?? false;
    });
  }

  Future<void> _toggleFaceID(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFaceID', value);
    setState(() {
      _useFaceID = value;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.person_outline,
              title: 'Account Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettings(),
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettings(),
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.remove_red_eye_outlined,
              title: 'Appearance',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettings(),
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Log in with Face ID'),
              value: _useFaceID,
              onChanged: _toggleFaceID,
              activeColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
