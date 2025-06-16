import 'package:flutter/material.dart';

// Function to show a modal for editing user information (name, email, password)
void editingModal({
  required BuildContext context,
  required String title,
}) {
  String newInput = ''; // Placeholder for new name/email/password, this function does not actually change the name

  showDialog(
    context: context,
    builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded edges
        ),
        title: Text("Edit User $title"),
        content: SizedBox(
          width: screenWidth * 0.8,   // 80% of screen width
          height: screenHeight * 0.2, // 20% of screen height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newInput = value;
                },
                decoration: InputDecoration(hintText: "Enter new ${title.toLowerCase()}"),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  print("New name: $newInput");
                  Navigator.of(context).pop();
                },
                child: const Text("SAVE"),
              ),
            ],
          ),
        ),
      );
    },
  );
}
