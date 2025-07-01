import 'package:flutter/material.dart';
import 'editing_text_field.dart';

class NameChange extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  NameChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Settings'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Change Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            const Text(
              'Please note you can only change your name once every 90 days and your username once every 30 days',
              style: TextStyle(fontSize:16),
            ),
            const SizedBox(height: 20),

          // First Name Editing Box
            const Text(
              "First Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            EditingTextField(
              labelText: 'Jane', // Placeholder for first name
              controller: firstNameController),
            const SizedBox(height: 10),

          // Last name editing box
            const Text(
              "Last Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            EditingTextField(
              labelText: 'Doe', // Placeholder for last name
              controller: lastNameController),
            const SizedBox(height:10),

          // Username editing box
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            EditingTextField(
              labelText: 'jane_doe123', // Placeholder for username
              controller: usernameController),
            const SizedBox(height:10),

            // Save changes button
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              onPressed: () {
                // Logic to change the name goes here
                Navigator.pop(context); // Go back after changing name
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
