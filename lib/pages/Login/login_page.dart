import 'package:flutter/material.dart';
import 'package:m2mapp/pages/Home/Landing.dart';
import 'package:m2mapp/pages/Intro/training_selection.dart';
import 'package:m2mapp/pages/SignUp/sign_up_page.dart';

// We have to discuss what kind of backend we are using for user data handling like signing up.
// Firebase???
// Once the user is signed in for the first time -> ask them if they would like to use biometric auth to sign into the application from now on.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    //Insert Log In Photo in this Sized Box
                    const SizedBox(height: 100),
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
                      ),
                      obscureText: false,
                      cursorColor: Colors.black,
                    ),
                    const SizedBox(height: 10),

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

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(fontSize: 13),
                          overlayColor: null,
                        ),
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
                          // The Login button currently submits to nothing.
                          // Currently goes to the next page (training page)
                          MaterialPageRoute(
                            builder: (context) => const TrainingSelectionPage(),
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
                        overlayColor: null,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
