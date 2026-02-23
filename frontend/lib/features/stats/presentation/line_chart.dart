import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ForceOutputLineChart extends StatelessWidget {
  const ForceOutputLineChart({
    super.key,
    required this.lineData, // 7 values, Mon..Sun
  });

  final List<double> lineData;

  @override
  Widget build(BuildContext context) {
    assert(lineData.length == 7, 'Expected 7 values for lineData (Mon..Sun)');

    final maxValue = lineData.reduce((a, b) => a > b ? a : b);
    final computedMaxY = maxValue *
        1.2; // Add 20% headroom for better visualization (so line does not exceed graph)

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Force Output',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text('Average force percentage over the past week',
          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      const SizedBox(height: 12),
      AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
                minY: 0,
                minX: 0,
                maxY: computedMaxY,
                maxX: 6,

                // Grid lines
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
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        if (value % 25 != 0) return const SizedBox.shrink();
                        return Text('${value.toInt()}%',
                            style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];

                        final i = value.toInt();
                        if (i < 0 || i >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(days[i]));
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(lineData.length,
                        (index) => FlSpot(index.toDouble(), lineData[index])),
                    isCurved: false,
                    barWidth: 3,
                    color: Colors.blue,

                    // Circle markers with white inside
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.blue,
                          );
                        }),
                  ),
                ]),
          )),
    ]);
  }
}
