import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:m2mapp/pages/Login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IntroPages(),
    );
  }
}

class IntroPages extends StatefulWidget {
  const IntroPages({super.key});

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Track the current page index

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper method to build a page
  Widget _buildPage({
    required String photoUrl,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        // Use Expanded to center content vertically
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Photo
              Image.asset(
                photoUrl,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
              const SizedBox(height: 20), // Reduced spacing
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Increased font size for better visibility
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Reduced spacing
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Expanded PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index; // Update the current page index
                });
              },
              children: [
                _buildPage(
                  photoUrl: 'assets/hand_pinch.png',
                  title: 'Complete Exercises',
                  description:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
                ),
                _buildPage(
                  photoUrl: 'assets/hand_balloon.png',
                  title: 'Play Interactive Games',
                  description:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
                ),
                _buildPage(
                  photoUrl: 'assets/hand_phone.png',
                  title: 'Track Your Progress',
                  description:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
                ),
              ],
            ),
          ),

          // SmoothPageIndicator
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
                dotColor: Colors.grey,
                activeDotColor: Colors.grey.shade700,
              ),
            ),
          ),

          // "Next" or "Get Started" Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < 2) {
                  // Go to the next page
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Navigate to the LoginPage on the last page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                _currentPage == 2 ? 'Get Started' : 'Next',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
