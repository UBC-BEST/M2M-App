import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2mapp/pages/Login/login_page.dart';

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
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
