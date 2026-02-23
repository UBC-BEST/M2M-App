import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';
import 'package:m2m/features/auth/presentation/login/login_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final slides = _buildSlides(localizations);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentIndex > 0)
                    TextButton(
                      onPressed: _handleBack,
                      child: Text(localizations.backButtonLabel),
                    )
                  else
                    const SizedBox(width: 64),
                  TextButton(
                    onPressed: _skip,
                    child: Text(localizations.skipButtonLabel),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _OnboardingSlide(slide: slide);
                },
              ),
            ),
            _buildIndicators(slides.length, colorScheme.primary),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleNext,
                  child: Text(
                    _isLastSlide(slides.length)
                        ? localizations.getStartedButtonLabel
                        : localizations.nextButtonLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_OnboardingSlideData> _buildSlides(AppLocalizations localizations) {
    return [
      _OnboardingSlideData(
        title: localizations.onboardingExerciseTitle,
        description: localizations.onboardingExerciseDescription,
      ),
      _OnboardingSlideData(
        title: localizations.onboardingGamesTitle,
        description: localizations.onboardingGamesDescription,
      ),
      _OnboardingSlideData(
        title: localizations.onboardingProgressTitle,
        description: localizations.onboardingProgressDescription,
      ),
    ];
  }

  Widget _buildIndicators(int length, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          final isActive = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 8,
            width: isActive ? 32 : 12,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  void _handleBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleNext() {
    final slides = _buildSlides(AppLocalizations.of(context)!);
    if (_isLastSlide(slides.length)) {
      _finish();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skip() => _finish();

  bool _isLastSlide(int length) => _currentIndex == length - 1;

  void _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.slide,
  });

  final _OnboardingSlideData slide;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 120),
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              slide.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
