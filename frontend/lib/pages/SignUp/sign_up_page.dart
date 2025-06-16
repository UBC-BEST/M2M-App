import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m2mapp/config.dart';
import 'dart:convert';
import 'package:m2mapp/pages/Intro/training_selection.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    final String email = emailController.text.trim();
    final String displayName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}';
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    print('Sending POST to $serverEndpoint/auth/register');
    print(jsonEncode({
      'email': email,
      'displayName': displayName,
      'password': password,
    }));

    if (password != confirmPassword) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final url = Uri.parse('$serverEndpoint/auth/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'displayName': displayName,
        'password': password,
      }),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrainingSelectionPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }

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
                      controller: firstNameController,
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
                      controller: lastNameController,
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
                      controller: emailController,
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
                      controller: passwordController,
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
                      controller: confirmPasswordController,
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
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue.shade600,
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            onPressed: registerUser,
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
