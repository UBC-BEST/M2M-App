import 'package:flutter/material.dart';
import 'package:m2mapp/pages/Home/Landing.dart';
import 'package:m2mapp/pages/SignUp/sign_up_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email Field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Color when the field is not focused
                          width:
                              1.0, // Width of the border when unfocused (optional)
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    obscureText: false,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 13, color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Color when the field is not focused
                          width:
                              1.0, // Width of the border when unfocused (optional)
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

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(fontSize: 13)),
                      onPressed: () {
                        // Handle forgot password action
                      },
                      child: const Text(
                        'Forgot Password?',
                      ),
                    ),
                  ),

                  // Login Button
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
                          builder: (context) => const Navigation(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),

                  // Create Account Button
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
