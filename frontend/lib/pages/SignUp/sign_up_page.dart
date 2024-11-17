import 'package:flutter/material.dart';
import 'package:m2mapp/pages/Intro/training_selection.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),

      // Gesture Detector is used so that when the user clicks out of the textbox, the keyboard will disappear
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle:
                            TextStyle(fontSize: 13, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                    ),
                    const SizedBox(height: 16),

                    // Last Name Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle:
                            TextStyle(fontSize: 13, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(fontSize: 13, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    // This field uses Obscure to hide the password that the user is inputting
                    // Maybe add a "show password" button or something?? I find this useful sometimes
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(fontSize: 13, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle:
                            TextStyle(fontSize: 13, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Sign Up Button
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade600,
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrainingSelectionPage(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),

                    // Already have an Account Button
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Already have an account? Log in"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
