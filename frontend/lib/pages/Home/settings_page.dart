import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //Might remove, seems redundant
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 203, 232, 236), // AppBar color
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _settingsButton(context, "Name", () => editNameModal(context)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _settingsButton(context, "Email",  () => editEmailModal(context)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _settingsButton(context, "Password", () => editPasswordModal(context)),
              ),
            ],
          ),
       ),
      ),
    );
  }
}

// _settingsButton: button that navigates to defined modal when pressed
Widget _settingsButton(BuildContext context, String title, VoidCallback onPressed) {
  return Center(
    child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65, // width of button is 65% of screen width
        height: MediaQuery.of(context).size.height * 0.15, // height of button is 15% of screen height
          child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // padding 8px horizontal and 16px vertical
            backgroundColor: Colors.white, // Background color of button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded edges
              side: const BorderSide(color: Color(0xFFBEBAB3)), // Border color
            ),
          ),
          /*onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }, */
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Text color;
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
            ),
          ),
        ),
    );
}

// editNameModal: Modal that pops up after button press to edit username
void editNameModal(BuildContext context) {
  String newName = ''; // Placeholder for new name

  showDialog(
    context: context,
    builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded edges
        ),
        title: const Text("Edit User Name"),
        content: SizedBox(
          width: screenWidth * 0.8,   // 80% of screen width
          height: screenHeight * 0.2, // 20% of screen height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: const InputDecoration(hintText: "Enter new name"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("New name: $newName");
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

//editEmailModal: Email editing modal that pops up after button press
void editEmailModal(BuildContext context) {
  String newEmail = ''; // Placeholder for new name

  showDialog(
    context: context,
    builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded edges
        ),
        title: const Text("Edit User Email"),
        content: SizedBox(
          width: screenWidth * 0.8,   // 80% of screen width
          height: screenHeight * 0.2, // 20% of screen height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newEmail = value;
                },
                decoration: const InputDecoration(hintText: "Enter new email"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("New email: $newEmail");
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

//editPasswordModal: Password editing modal that pops up after button press
void editPasswordModal(BuildContext context) {
  String newPassword = ''; // Placeholder for new name

  showDialog(
    context: context,
    builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded edges
        ),
        title: const Text("Edit User Password"),
        content: SizedBox(
          width: screenWidth * 0.8,   // 80% of screen width
          height: screenHeight * 0.2, // 20% of screen height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: const InputDecoration(hintText: "Enter new password"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("New password: $newPassword");
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