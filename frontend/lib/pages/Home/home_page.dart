// pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            'Landing page',
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}

/*
All asynchronous functions

authenticate(): Triggers the authentication (uses the device's authentication ui)
- localizedReason (reason for authentication that will be displayed to user)
- options (AuthenticationOptions widget that takes fields to determine how the authentication works)
-    ex. biometricOnly: true makes it enforce biometrics
- uses the system's default biometrics if the device supports multiple biometrics (android is fingerprint and apple is faceid?)

canCheckBiometrics(): Checks if the device is capable of biometric capabilities

isDeviceSupported(): Checks if the device is capable of supporting either biometric OR passcode authentication (if no passcode authentication, evaluates to false)

getAvailableBiometrics(): Returns a list of biometrics that are enrolled on the device

 */

class HomePageAuth extends StatefulWidget {
  const HomePageAuth({super.key});

  @override
  State<HomePageAuth> createState() => _HomePageAuthState();
}

class _HomePageAuthState extends State<HomePageAuth> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometrics =
              await _auth.canCheckBiometrics;
          print(await _auth.isDeviceSupported());
          print(await _auth.canCheckBiometrics);
          print(await _auth.getAvailableBiometrics());
          if (canAuthenticateWithBiometrics) {
            try {
              final bool didAuthenticate = await _auth.authenticate(
                localizedReason: 'Please authenticate to show home page',
                options: const AuthenticationOptions(
                  biometricOnly: true,
                ),
              );
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } catch (e) {
              print(e);
            }
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: Icon(
        _isAuthenticated ? Icons.lock : Icons.lock_open,
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Center(
            child: _isAuthenticated
                ? const Text(
                    "M2M Secure Info",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null));
  }
}
