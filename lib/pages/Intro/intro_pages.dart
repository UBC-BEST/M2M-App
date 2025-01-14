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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView to hold multiple intro pages
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index; // Update the current page index
              });
            },
            children: [
              _buildPage(
                title: 'Complete exercises',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
              ),
              _buildPage(
                title: 'Play interactive games',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
              ),
              _buildPage(
                title: 'Track your progress',
                description:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus congue suscipit mollis. Vivamus eros purus.',
              ),
            ],
          ),

          // SmoothPageIndicator
          Positioned(
            bottom: 150, // Lowered the position of the SmoothPageIndicator
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotHeight: 9,
                  dotWidth: 9,
                  spacing: 8,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.grey.shade700,
                ),
              ),
            ),
          ),

          // "Next" or "Get Started" Button
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
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
              ),
              child: Text(
                style: const TextStyle(color: Colors.white),
                _currentPage == 2
                    ? 'Get Started'
                    : 'Next', // Change text dynamically
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a page
  Widget _buildPage({required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add some spacing above the text
        const Spacer(flex: 3),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        // Add more spacing to push everything down
        const SizedBox(height: 250),
      ],
    );
  }
}
