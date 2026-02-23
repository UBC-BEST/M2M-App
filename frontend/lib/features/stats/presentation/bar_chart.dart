import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RepsCompletedBarChart extends StatelessWidget {
  const RepsCompletedBarChart({
    super.key,
    required this.reps, // 7 values, Mon..Sun
    this.maxY = 20,
  });

  final List<int> reps;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Repetitions Completed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text('Daily repetition count',
          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      const SizedBox(height: 12),
      AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              minY: 0,
              maxY: 10,

              // Add grid lines
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                  dashArray: [6, 6],
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                  dashArray: [6, 6],
                ),
              ),

              // Axes borders
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),

              // Titles for axes
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 != 0) return const SizedBox.shrink();
                          return Text(value.toInt().toString(),
                              style: const TextStyle(fontSize: 12));
                        })),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final dayLabels = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          if (value.toInt() < 0 ||
                              value.toInt() >= dayLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(dayLabels[value.toInt()],
                              style: const TextStyle(fontSize: 12));
                        })),
              ),

              barGroups: List.generate(7, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: reps[i].toDouble(),
                      width: 18,
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xFF7C4DFF), // purple
                    ),
                  ],
                );
              }),
            ),
          ))
    ]);
  }
}
