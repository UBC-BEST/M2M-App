import 'package:flutter/material.dart';
import 'settings_tile.dart';
import 'name_change.dart'; 
import 'email_change.dart';
import 'password_change.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for user data, this should be replaced with actual user data from the database
    String currentName = "Jane Doe"; // Placeholder for current name
    String currentEmail = "jane123@gmail.com"; // Placeholder for current email
    String currentPassword = "********"; // Placeholder for current password

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        backgroundColor: Colors.white, // AppBar color
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.badge_outlined, 
              title: 'Name & Username',
              subtitle: currentName, // Display current name
              onTap:() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NameChange()),
              ),
            ),

            SettingsTile(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: currentEmail, // Display current email
              onTap:() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailChange()),
              ),
            ),

            SettingsTile(
              icon: Icons.lock_outline,
              title: 'Password',
              subtitle: currentPassword, // Display current password (masked)
              onTap:() => Navigator.push(
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



