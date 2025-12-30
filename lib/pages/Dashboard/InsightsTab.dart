import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';
import 'package:beebetter/widgets/mood_trend_chart.dart';

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
                  size: 24,
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
                            size: 24,
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
            const SizedBox(height: 16),
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
                            const SizedBox(height: 16),
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
                            size: 24,
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
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.inversePrimary.withAlpha(40),
                                    shape: BoxShape.circle,
                                  ),
                          child: Icon(
                            Symbols.bolt_rounded,
                            size: 24,
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

            const SizedBox(height: 16),

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
                            size: 24,
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
                  size: 24,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "This Week's Mood Trend",
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
                child: logic.totalEntries == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.show_chart_rounded,
                            size: 48,
                            color: colorScheme.primary.withAlpha(128),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No data yet",
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary.withAlpha(160),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Start journaling to see your mood trends",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary.withAlpha(128),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : MoodTrendChart(
                        color: colorScheme.primary,
                        secondaryColor: colorScheme.inversePrimary,
                        moodValues: logic.moodValues,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // ---------------------------------------------------
            // Advanced Insights
            // ---------------------------------------------------
            if (logic.totalEntries > 0) ...[
            Row(
              children: [
                Icon(
                  Symbols.insights_rounded,
                  size: 24,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "Advanced Insights",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
              const SizedBox(height: 16),
              // Average Mood Score
              Card(
                color: colorScheme.onPrimary,
                shadowColor: colorScheme.inversePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.inversePrimary.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child:                           Icon(
                            Symbols.psychology_rounded,
                            size: 28,
                            color: colorScheme.primary.withAlpha(240),
                          ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Mood",
                              style: textTheme.titleSmall
                                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                            ),
                            Text(
                              "${(logic.averageMoodScore).toStringAsFixed(1)} / 4.0",
                              style: textTheme.titleLarge
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      // Mood indicator
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getMoodColor(logic.averageMoodScore, colorScheme),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getMoodIcon(logic.averageMoodScore),
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Best/Worst Mood Days
              Row(
                children: [
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Symbols.trending_up_rounded,
                                  size: 20,
                                  color: colorScheme.primary.withAlpha(200),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Best Day",
                                  style: textTheme.titleSmall
                                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              logic.getDayName(logic.bestMoodDay),
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Symbols.trending_down_rounded,
                                  size: 20,
                                  color: colorScheme.primary.withAlpha(200),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Most Active",
                                  style: textTheme.titleSmall
                                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              logic.mostActiveDay,
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Longest Streak
              if (logic.longestStreak > 0)
                Card(
                  color: colorScheme.onPrimary,
                  shadowColor: colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.inversePrimary.withAlpha(40),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Symbols.local_fire_department_rounded,
                            size: 24,
                            color: colorScheme.primary.withAlpha(240),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Longest Streak",
                                style: textTheme.titleSmall
                                    ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                              ),
                              Text(
                                "${logic.longestStreak} days",
                                style: textTheme.titleLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
            
            // ---------------------------------------------------
            // Entry Types
            // ---------------------------------------------------
            Row(
              children: [
                Icon(
                  Symbols.article_rounded,
                  size: 24,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "Entry Types",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.inversePrimary.withAlpha(40),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Symbols.text_fields_rounded,
                                  size: 24,
                                  color: colorScheme.primary.withAlpha(240),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Text Entries",
                                      style: textTheme.titleSmall
                                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                    ),
                                    Text(
                                      "${logic.textEntriesCount}",
                                      style: textTheme.titleLarge
                                          ?.copyWith(color: colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.inversePrimary.withAlpha(40),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Symbols.mic_rounded,
                                  size: 24,
                                  color: colorScheme.primary.withAlpha(240),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Voice Entries",
                                      style: textTheme.titleSmall
                                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                                    ),
                                    Text(
                                      "${logic.voiceEntriesCount}",
                                      style: textTheme.titleLarge
                                          ?.copyWith(color: colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // ---------------------------------------------------
            // Top Emotions
            // ---------------------------------------------------
            Row(
              children: [
                Icon(
                  Symbols.emoji_emotions_rounded,
                  size: 24,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "Most Common Emotions",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: logic.getTopEmotions().isEmpty
                    ? Center(
                        child: Text(
                          "No emotions recorded yet",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: logic.getTopEmotions().map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: textTheme.bodyLarge
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.inversePrimary.withAlpha(40),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${entry.value}",
                                    style: textTheme.bodyMedium
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ]
      ),
    );
  }

  Color _getMoodColor(double score, ColorScheme colorScheme) {
    if (score >= 3.5) return colorScheme.tertiary; // Very positive - pink
    if (score >= 2.5) return colorScheme.primary; // Positive - indigo
    if (score >= 1.5) return colorScheme.secondary; // Neutral - purple
    if (score >= 0.5) return Colors.orange; // Negative - orange
    return colorScheme.error; // Very negative - red
  }

  IconData _getMoodIcon(double score) {
    if (score >= 3.5) return Symbols.sentiment_very_satisfied;
    if (score >= 2.5) return Symbols.sentiment_satisfied;
    if (score >= 1.5) return Symbols.sentiment_neutral;
    if (score >= 0.5) return Symbols.sentiment_dissatisfied;
    return Symbols.sentiment_very_dissatisfied;
  }
}