import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

// Importing bar chart and line chart widgets
import 'bar_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Sample data for charts (replace with real data)
    final weeklyReps = [10, 15, 20, 25, 30, 35, 40];

    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: SizedBox.expand(
        child: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(localizations.statsPageTitle, style: theme.textTheme.headlineMedium),

              const SizedBox(height: 24),

              // Bar chart for repetitions
              RepsCompletedBarChart(reps: weeklyReps),

              const SizedBox(height: 32),

              // Line chart for progress
              // LineChartSample(lineData: sampleLineData),
            ],
          ),
        )),
      ),
    );
  }
}
