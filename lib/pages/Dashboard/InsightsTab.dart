import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';
import 'package:beebetter/widgets/MoodTrendChart.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.read<DashboardLogic>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
          children: [

            // ---------------------------------------------------
            // Activity Summary
            // ---------------------------------------------------
            Row(
              children: [
                Icon(
                  Symbols.analytics_rounded,
                  size: 32,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "Activity Summary",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),

            // ---------------------------------------------------
            // Total Entries
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // ---------------------------------------------------
                        // Icon
                        // ---------------------------------------------------
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.inversePrimary.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Symbols.menu_book_rounded,
                            size: 32,
                            color: colorScheme.primary.withAlpha(240),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // ---------------------------------------------------
                        // Total Entries
                        // ---------------------------------------------------
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Entries:",
                                  style: textTheme.titleMedium
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                                Text(
                                  "${logic.totalEntries}",
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            // ---------------------------------------------------
            // Daily Tracking
            // ---------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // Days Tracked
                // ---------------------------------------------------
                Expanded(
                  child: Card(
                    color: colorScheme.onPrimary,
                    shadowColor: colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Days Tracked",
                              style: textTheme.titleMedium
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.inversePrimary.withAlpha(40),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Symbols.calendar_today_rounded,
                                    size: 32,
                                    color: colorScheme.primary.withAlpha(240),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${logic.daysTracked}",
                                        style: textTheme.bodyLarge
                                            ?.copyWith(color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ---------------------------------------------------
                // Streak
                // ---------------------------------------------------
                Expanded(
                  child: Card(
                    color: colorScheme.onPrimary,
                    shadowColor: colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Streak",
                              style: textTheme.titleMedium
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.inversePrimary.withAlpha(30),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Symbols.bolt_rounded,
                                    size: 32,
                                    color: colorScheme.inversePrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${logic.streak}",
                                        style: textTheme.bodyLarge
                                            ?.copyWith(color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ---------------------------------------------------
            // Overall Mood
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Mood",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // ---------------------------------------------------
                        // Icon
                        // ---------------------------------------------------
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.inversePrimary.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Symbols.sentiment_excited_rounded,
                            size: 32,
                            color: colorScheme.primary.withAlpha(240),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // ---------------------------------------------------
                        // Overall Mood
                        // ---------------------------------------------------
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${logic.overallMood}",
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                                Text(
                                  "${logic.overallMoodPercentage}%",
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Mood Trend Chart
            // ---------------------------------------------------
            Row(
              children: [
                Icon(
                  Symbols.trending_up_rounded,
                  size: 32,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "This Weeks's Mood Trend",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child:
                MoodTrendChart(
                  color: colorScheme.primary,
                  moodValues: logic.moodValues,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ]
      ),
    );
  }
}