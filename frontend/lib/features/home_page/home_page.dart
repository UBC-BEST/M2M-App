import 'package:flutter/material.dart';
import 'widgets/recommended_card.dart';
import 'widgets/wide_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = "Jane";
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        children: [
          Text(
            '${localizations.hello},',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 36,
            ),
          ),
          Text(
            userName,
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 48,
              height: 0.9,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            "Recommended for you",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 215,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final cards = [
                  (
                    color: const Color.fromARGB(255, 113, 158, 102),
                    icon: Icons.compass_calibration,
                    title: "Calibration",
                    subtitle: "MAINTENANCE",
                    duration: "2-3 MIN"
                  ),
                  (
                    color: const Color(0xFFBEB9FF),
                    icon: Icons.spa,
                    title: "Grip Test",
                    subtitle: "EXERCISE",
                    duration: "3-10 MIN"
                  ),
                  (
                    color: const Color(0xFFA7C8FF),
                    icon: Icons.self_improvement,
                    title: "Range Test",
                    subtitle: "EXERCISE",
                    duration: "3-10 MIN"
                  ),
                ];
                final card = cards[index];
                return RecommendedCard(
                  color: card.color,
                  icon: card.icon,
                  title: card.title,
                  subtitle: card.subtitle,
                  duration: card.duration,
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          WideCard(
            color: const Color(0xFF23232C),
            textColor: Colors.white,
            title: "Daily Warm-up",
            subtitle: "STRETCHING • 3-10 MIN",
          ),
          const SizedBox(height: 14),
          WideCard(
            color: const Color(0xFFD2F6D3),
            textColor: Colors.black,
            title: "Weekly Challenge",
            subtitle: "STRETCHING • 3-10 MIN",
          ),
          // Add a bottom spacer for safety
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
