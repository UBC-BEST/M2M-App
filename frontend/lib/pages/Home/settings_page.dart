import 'package:flutter/material.dart';
import 'name_setting_page.dart';
import 'email_setting_page.dart';
import 'password_setting_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            //TPrimaryHeaderContainer(child: child),
            //Do I need a header? I saw this in a Youtube tutorial so...


            // name_setting_page(): own page for name changes, button navigates here
            // email_setting_page(): own page for email changes
            // password_setting_page(): own page for password changes
            _settingsButton(context, "Name", NameSettingPage()),
            _settingsButton(context, "Email", EmailSettingPage()),
            _settingsButton(context, "Password", PasswordSettingPage()),
          ],
        ),
      ),
       
    );
  }
}




// _settingsButton: button that navigates to defined screen when pressed
Widget _settingsButton(BuildContext context, String title, Widget screen) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15), //haven't put in actual dimensions yet
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(title),
    ),
  );
}
