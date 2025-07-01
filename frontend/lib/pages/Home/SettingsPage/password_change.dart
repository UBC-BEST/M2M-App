import 'package:flutter/material.dart';
import 'editing_text_field.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController reEnterNewPassController = TextEditingController();
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    newPassController.addListener(_evaluatePasswordStrength);
  }

  // _hasSpecialCharacter checks if the password contains at least one special character
  bool _hasSpecialCharacter(String input) {
  return RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(input);
  }

  // _evaluatePasswordStrength checks the password strength and updates the validation message
  // Doesn't stops the user from clicking button to save
  @override
  void _evaluatePasswordStrength() {
    final password = newPassController.text;

    setState(() {
      if (password.length < 6) {
        _validationMessage = 'Password must be at least 6 characters long.';
      } else if (!_hasSpecialCharacter(password)) {
        _validationMessage = 'Password must include at least one special character (!@#\$%^&*).';
      } else {
        _validationMessage = null; // Password is valid
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Settings'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            const Text(
              'Your password must be at least 6 characters long, and should include a combination of numbers, letters, and special characters (!@#\$%^&*).',
              style: TextStyle(fontSize:16),
            ),
            const SizedBox(height: 20),

            // Enter current password
            const Text(
              "Current Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            EditingTextField(
              labelText: 'Current password', 
              controller: currentPassController),
            const SizedBox(height: 20),

            // Enter new password
            const Text(
              "New Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // From _evaluatePasswordStrength, formats the validation message
            if (_validationMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _validationMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            EditingTextField(
              labelText: 'New password', 
              controller: newPassController,
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Re-enter new password
            EditingTextField(
              labelText: 'Re-enter new password', 
              controller: reEnterNewPassController,
              obscureText: true),

            // Forget your password link
            TextButton(
              onPressed: () {
                // Logic to handle password reset
              },
              child: const Text(
                'Forgot your password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),

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
