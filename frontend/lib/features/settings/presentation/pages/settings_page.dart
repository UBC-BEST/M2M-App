import 'package:flutter/material.dart';
import 'package:m2m/core/services/bluetooth_device_manager.dart';
import 'package:m2m/l10n/app_localizations.dart';
import 'package:m2m/core/services/session_manager.dart';
import 'package:m2m/features/auth/presentation/login/login_page.dart';

import '../widgets/settings_tile.dart';
import 'account_settings.dart';
import 'appearance_settings.dart';
import 'bluetooth_device_page.dart';
import 'notifications_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // TODO: store FaceID as a part of a backend user setting
  bool _useFaceId = false;
  late final SessionManager _sessionManager;
  late final BluetoothDeviceManager _bluetoothDeviceManager;
  String? _selectedBluetoothDevice;

  @override
  void initState() {
    super.initState();
    _sessionManager = SessionManager();
    _bluetoothDeviceManager = BluetoothDeviceManager();
    _loadFaceIdPreference();
    _loadBluetoothSelection();
  }

  Future<void> _loadFaceIdPreference() async {
    final enabled = await _sessionManager.isFaceIdEnabled();
    if (!mounted) return;
    setState(() => _useFaceId = enabled);
  }

  Future<void> _toggleFaceId(bool value) async {
    await _sessionManager.updateFaceIdPreference(enabled: value);
    if (!mounted) return;
    setState(() => _useFaceId = value);
  }

  Future<void> _loadBluetoothSelection() async {
    final selectedDevice = await _bluetoothDeviceManager.readSelectedDevice();
    if (!mounted) return;
    setState(() => _selectedBluetoothDevice = selectedDevice?.displayName);
  }

  Future<void> _logout() async {
    await _sessionManager.clearSession();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.person_outline,
              title: localizations.accountSettings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettings(),
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.notifications_outlined,
              title: localizations.notifications,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettings(),
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.remove_red_eye_outlined,
              title: localizations.appearance,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettings(),
                ),
              ),
            ),
            SettingsTile(
              icon: Icons.bluetooth_searching,
              title: 'Bluetooth Device',
              subtitle: _selectedBluetoothDevice ?? 'Not selected',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BluetoothDevicePage(),
                  ),
                );
                await _loadBluetoothSelection();
              },
            ),
            SwitchListTile(
              title: Text(localizations.loginWithFaceId),
              value: _useFaceId,
              onChanged: _toggleFaceId,
              //activeThumbColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _logout(),
              icon: const Icon(Icons.logout),
              label: Text(localizations.logout),
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
