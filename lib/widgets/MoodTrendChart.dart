import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTrendChart extends StatelessWidget {
  final color;
  final moodValues;

  MoodTrendChart({
    required this.color,
    required this.moodValues,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 170,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 4,

          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            drawVerticalLine: false,
          ),

          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            // X AXIS days of the week
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      days[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),

            // Y AXIS mood icons
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final icons = [
                    Icons.sentiment_very_dissatisfied,
                    Icons.sentiment_dissatisfied,
                    Icons.sentiment_neutral,
                    Icons.sentiment_satisfied,
                    Icons.sentiment_very_satisfied,
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      icons[value.toInt()],
                      size: 14,
                      color: color,
                    ),
                  );
                },
              ),
            ),

            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                moodValues.length,
                    (i) => FlSpot(i.toDouble(), moodValues[i].toDouble()),
              ),
              isCurved: true,
              color: color,
              barWidth: 2,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
