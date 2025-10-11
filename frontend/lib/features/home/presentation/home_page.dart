import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

import 'widgets/recommended_card.dart';
import 'widgets/wide_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'Jane';
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    final recommendedCards = _recommendedContent(localizations);
    final spotlightCards = _spotlightContent(localizations);

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
            localizations.recommendedSectionTitle,
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
              itemCount: recommendedCards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final card = recommendedCards[index];
                return RecommendedCard(
                  color: card.color,
                  icon: card.icon,
                  title: card.title,
                  subtitle: card.subtitle,
                  duration: card.duration,
                  ctaLabel: localizations.startButtonLabel,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          for (final spotlight in spotlightCards) ...[
            WideCard(
              color: spotlight.color,
              textColor: spotlight.textColor,
              title: spotlight.title,
              subtitle: spotlight.subtitle,
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<_RecommendedContent> _recommendedContent(AppLocalizations localizations) {
    return [
      _RecommendedContent(
        color: const Color(0xFF719E66),
        icon: Icons.compass_calibration,
        title: localizations.calibrationTitle,
        subtitle: localizations.maintenanceLabel,
        duration: localizations.durationTwoToThreeMinutes,
      ),
      _RecommendedContent(
        color: const Color(0xFFBEB9FF),
        icon: Icons.spa,
        title: localizations.gripTestTitle,
        subtitle: localizations.exerciseLabel,
        duration: localizations.durationThreeToTenMinutes,
      ),
      _RecommendedContent(
        color: const Color(0xFFA7C8FF),
        icon: Icons.self_improvement,
        title: localizations.rangeTestTitle,
        subtitle: localizations.exerciseLabel,
        duration: localizations.durationThreeToTenMinutes,
      ),
    ];
  }

  List<_SpotlightContent> _spotlightContent(AppLocalizations localizations) {
    return [
      _SpotlightContent(
        color: const Color(0xFF23232C),
        textColor: Colors.white,
        title: localizations.dailyWarmupTitle,
        subtitle: localizations.dailyWarmupSubtitle,
      ),
      _SpotlightContent(
        color: const Color(0xFFD2F6D3),
        textColor: Colors.black,
        title: localizations.weeklyChallengeTitle,
        subtitle: localizations.weeklyChallengeSubtitle,
      ),
    ];
  }
}

class _RecommendedContent {
  const _RecommendedContent({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final String duration;
}

class _SpotlightContent {
  const _SpotlightContent({
    required this.color,
    required this.textColor,
    required this.title,
    required this.subtitle,
  });

  final Color color;
  final Color textColor;
  final String title;
  final String subtitle;
}
