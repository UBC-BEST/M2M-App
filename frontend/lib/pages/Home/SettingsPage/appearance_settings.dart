import 'package:flutter/material.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  String newFontSize = 'Default'; // Default font size
  String newTheme = 'Light'; // Default theme

  final fontSizes = ['Small', 'Default', 'Large'];
  final modes = ['Light', 'Dark'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),

      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
            // Font Size
            _appearanceTile(
              icon: Icons.text_fields,
              title: 'Font Size',
              value: newFontSize,
              items: fontSizes,
              onChanged: (String? val) {
                if (val != null) {
                  setState(() => newFontSize = val);
                }
              },
            ),

            // Theme Change
            _appearanceTile(
              icon: Icons.nightlight_round_outlined,
              title: 'Theme',
              value: newTheme,
              items: modes,
              onChanged: (String? val) {
                if (val != null) {
                  setState(() => newTheme = val);
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: () {
                // Logic to change new email goes here
                Navigator.pop(context);
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 Widget _appearanceTile({
  required IconData icon,
  required String title,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: DropdownButton<String>(
      value: value,
      underline: const SizedBox(),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      // Changes the dropdown menu text to the selected value but not actual app appearance
      onChanged: onChanged,
    ),
  );
}