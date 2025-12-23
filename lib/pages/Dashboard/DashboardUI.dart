import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';
import 'package:beebetter/pages/Dashboard/InsightsTab.dart';

class DashboardUI extends StatelessWidget {
  const DashboardUI({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final logic = context.read<DashboardLogic>();

    return DefaultTabController(
      length: 2,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Your Journey",
              style: textTheme.headlineSmall
                  ?.copyWith(color: colorScheme.primary),
            ),
            Text(
              "Track your progress and reflections",
              style: textTheme.titleMedium
                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),
            ),
            const SizedBox(height: 16),

            // ---------------------------------------------------
            // Tabs
            // ---------------------------------------------------
            TabBar(
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.primary.withAlpha(160),
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // center icon + text
                    children: [
                      Icon(Symbols.insights_rounded, size: 20), // your icon
                      const SizedBox(width: 6), // spacing between icon and text
                      const Text("Insights"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Symbols.search_rounded, size: 20),
                      const SizedBox(width: 6),
                      const Text("Browse"),
                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------
            // Tab Views
            // ---------------------------------------------------
            Expanded(
              child:
                TabBarView(
                  children: [
                    // ---------------------------------------------------
                    // Insights Tab
                    // ---------------------------------------------------
                    const InsightsTab(),

                    // ---------------------------------------------------
                    // Browse Tab
                    // ---------------------------------------------------
                    Center(
                      child: Text(
                        "calendar and previous entries",
                        style: textTheme.titleMedium,
                      ),
                    ),
                ]
              ),
            ),
        ]
      ),
    );
  }
}