import 'package:flutter/material.dart';
import 'package:m2mapp/pages/Intro/intro1_page.dart';
import 'intro3_page.dart';
import '../Login/login_page.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});
  // All of Intro Pages 1-3 contain the exact same code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wrap both button with SafeArea to avoid notches
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Top Left Skip Button
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const IntroPage1(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          // Custom slide transition for when the user wants to go back
                          const begin = Offset(-1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Back'),
                ),
              ),
            ),
          ),
          // Wrap both button with SafeArea to avoid notches or hole punches
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Top Right Text Button
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Skip'),
                ),
              ),
            ),
          ),

          // Centered Content (text and title pretty much)
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    const Text(
                      'Play Interactive Games',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IntroPage3(),
                            ),
                          );
                        },
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
