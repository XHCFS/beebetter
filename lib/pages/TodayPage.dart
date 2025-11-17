import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beebetter/pages/GuidedMode.dart';
import 'package:flutter/rendering.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';

class TodayPage extends StatelessWidget {
  final VoidCallback openGuidedMode;
  const TodayPage({super.key, required this.openGuidedMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        body:
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // top & horizontal padding
                child: TodayPageBody(openGuidedMode: openGuidedMode),
              ),
            ),
      ),
    );
  }
}


class TodayPageBody extends StatefulWidget {
  final VoidCallback openGuidedMode;
  const TodayPageBody({super.key, required this.openGuidedMode});
  @override
  State<TodayPageBody> createState() => _TodayPageBodyState();
}

class _TodayPageBodyState extends State<TodayPageBody> {
  double initialY = 0;

  @override
  Widget build(BuildContext context) {
    final String name = "name";
    final int completed = 0;
    final int total = 3;
    final DateTime today = DateTime.now();
    final String day = DateFormat('EEEE').format(today);
    final String formattedDate = DateFormat('MMMM d, yyyy').format(today);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color surfaceContainerDark = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withAlpha(20),
      Theme.of(context).colorScheme.surfaceContainerLow,
    );

    return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome back, ", style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: colorScheme.primary),),
                      const SizedBox(width: 4),
                      Text(name, style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: colorScheme.primary),),
                      const SizedBox(width: 4),
                      Text("!", style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: colorScheme.primary),),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(day, style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),),
                  Text(formattedDate, style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                  const SizedBox(height: 16),

                  Card(
                    // elevation: 2,
                    color: colorScheme.onPrimary,
                    shadowColor: colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      // side: BorderSide(color: colorScheme.inversePrimary, width: 1),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GuidedMode()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.edit,
                                size: 32,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "New Entry",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Journal your thoughts and mood",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: colorScheme.primary.withAlpha(100)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                      elevation: 2,
                      color: surfaceContainerDark,
                      shadowColor: colorScheme.inversePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        // side: BorderSide(color: colorScheme.inversePrimary, width: 1),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: widget.openGuidedMode,
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 32,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daily prompts",
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(color: colorScheme.primary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "$completed / $total completed",
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(color: colorScheme.primary.withAlpha(120)),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32),
                              Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 32,
                                color: colorScheme.inversePrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}