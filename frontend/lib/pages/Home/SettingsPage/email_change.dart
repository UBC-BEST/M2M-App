import 'package:flutter/material.dart';
import 'editing_text_field.dart';

class EmailChange extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  EmailChange({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Settings'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Change Email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 30),

              const Text(
                "New Email Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              EditingTextField(
                labelText: 'janedoe234@gmail.com', // Placeholder for current email
                controller: emailController),
              const SizedBox(height: 10),

              const Text(
                'Please enter your password to change your email address.',
                style: TextStyle(fontWeight: FontWeight.bold,),
              ),
              EditingTextField(
                labelText: 'Password', 
                controller: passwordController,
                obscureText: true,),

              const SizedBox(height: 50),
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
      ),
    );
  }
}
