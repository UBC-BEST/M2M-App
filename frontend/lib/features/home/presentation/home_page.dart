import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Jane';
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          children: [
            Text(
              '${localizations.hello},',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              userName,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                height: 1.0,
              ),
            ),
            const SizedBox(height: 22),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  SizedBox(width: 14),
                  Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                  SizedBox(width: 10),
                  Text(
                    'Search exercises...',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Recommended for you',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _HomeExerciseCard(
                    title: 'Grip Test',
                    accentColor: Color(0xFF0891B2),
                    gradientStart: Color(0xFF06B6D4),
                    gradientEnd: Color(0xFF0891B2),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _HomeExerciseCard(
                    title: 'Range Test',
                    accentColor: Color(0xFF0D9488),
                    gradientStart: Color(0xFF14B8A6),
                    gradientEnd: Color(0xFF0D9488),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Today's Activities",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: localizations.dailyWarmupTitle,
              subtitle: 'STRETCHING • 3-10 MIN',
              buttonColor: const Color(0xFF06B6D4),
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: localizations.weeklyChallengeTitle,
              subtitle: 'STRETCHING • 3-10 MIN',
              buttonColor: const Color(0xFF14B8A6),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeExerciseCard extends StatelessWidget {
  const _HomeExerciseCard({
    required this.title,
    required this.accentColor,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final String title;
  final Color accentColor;
  final Color gradientStart;
  final Color gradientEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStart, gradientEnd],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EXERCISE',
            style: TextStyle(
              color: Color(0xE6FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const Spacer(),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'START',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.buttonColor,
  });

  final String title;
  final String subtitle;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
