import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

// Importing bar chart and line chart widgets
import 'bar_chart.dart';
import 'line_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Sample data for charts (replace with real data)
    final samplebarData = [2, 5, 15, 7, 10, 30, 11];
    final sampleLineData = [20.0, 35.0, 50.0, 40.0, 60.0, 80.0, 70.0];

    return Scaffold(
      /*appBar: AppBar(
        title: Text(localizations.statsPageTitle),
        backgroundColor: Colors.white,
        centerTitle: true,
      ), */
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.statsPageTitle,
                  style: theme.textTheme.headlineMedium),

              const SizedBox(height: 24),

              // Bar chart for repetitions
              RepsCompletedBarChart(reps: samplebarData),

              const SizedBox(height: 32),

              // Line chart for progress
              ForceOutputLineChart(lineData: sampleLineData),
            ],
          ),
        ),
      ),
    );
  }
}
