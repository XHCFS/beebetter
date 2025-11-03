import 'package:flutter/material.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:intl/intl.dart';
import 'package:beebetter/main.dart';

class GuidedMode extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BackgroundGradient(
        body:
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // top & horizontal padding
            child: GuidedModeBody(),
          ),
        ),
      ),
    );
  }
}

class GuidedModeBody extends StatefulWidget {
  const GuidedModeBody({super.key});
  @override
  State<GuidedModeBody> createState() => _GuidedModeBodyState();
}

class _GuidedModeBodyState extends State<GuidedModeBody> {
  int totalPrompts = 3;
  int completedPrompts = 1;
  String promptCategory = "productivity";
  String prompt = "What's one small win you had today?";
  bool canContinue = false;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final String day = DateFormat('EEEE').format(today);
    final String formattedDate = DateFormat('MMMM d, yyyy').format(today);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MainPage(),
              transitionsBuilder: (_, animation, __, child) =>
                  SlideTransition(
                    position: Tween(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // const SizedBox(height: 4),
            Center(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(day, style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),),
                  Text(formattedDate, style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    color: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.inversePrimary.withAlpha(120), width: 1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("Daily Prompts", style: textTheme.titleLarge
                              ?.copyWith(color: colorScheme.primary),),
                          const SizedBox(height: 16),

                          // ---------------------------------------------------
                          // Progress bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Progress", style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                              Text("$completedPrompts / $totalPrompts", style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                            ],
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: completedPrompts / totalPrompts,
                                backgroundColor: colorScheme.surfaceContainerLow,
                                color: colorScheme.inversePrimary,
                                minHeight: 10,
                              ),
                            ),
                          ),
                          // ---------------------------------------------------

                          const SizedBox(height: 32),
                          Card(
                              // elevation: 0,
                              margin: EdgeInsets.zero,
                              color: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: colorScheme.inversePrimary, width: 1)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ---------------------------------------------------
                                    // Category
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: colorScheme.surfaceBright,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: colorScheme.inversePrimary, // or any color you want
                                            width: 1, // border thickness
                                          ),
                                        ),
                                        child: Text(
                                          '$promptCategory',
                                          style: textTheme.bodySmall
                                              ?.copyWith(color: colorScheme.inversePrimary),
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    // ---------------------------------------------------
                                    // Prompt
                                    Text("$prompt", style: textTheme.titleMedium
                                        ?.copyWith(color: colorScheme.primary),),
                                    // const SizedBox(height: 4),

                                    // ---------------------------------------------------
                                    // Tabs
                                    DefaultTabController(
                                      length: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(
                                              color: colorScheme.surfaceBright,
                                              borderRadius: BorderRadius.circular(12),
                                              // border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
                                            ),
                                            child: TabBar(
                                              padding: EdgeInsets.zero,
                                              labelPadding: EdgeInsets.zero,
                                              indicatorPadding: EdgeInsets.zero,
                                              // indicatorSize: TabBarIndicatorSize.tab,

                                              indicator: BoxDecoration(
                                                color: colorScheme.inversePrimary,
                                                borderRadius: BorderRadius.circular(12),
                                              ),

                                              labelColor: colorScheme.secondary,
                                              unselectedLabelColor: colorScheme.primary,
                                              dividerColor: Colors.transparent,
                                              tabs: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Icon(Icons.text_fields, size: 20),
                                                        SizedBox(width: 6),
                                                        Text("Text"),
                                                      ],
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child:
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Icon(Icons.mic, size: 20),
                                                        SizedBox(width: 6),
                                                        Text("Voice"),
                                                      ],
                                                    ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // const SizedBox(height: 16),

                                          SizedBox(
                                            height: 200,
                                            child: TabBarView(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  margin: EdgeInsets.zero,
                                                  color: colorScheme.surfaceBright,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),

                                                  child:Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: TextField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          canContinue = value.trim().isNotEmpty;
                                                        });
                                                      },
                                                      maxLines: null,
                                                      decoration: InputDecoration(
                                                        hintText: "Share your thoughts...",
                                                        hintStyle: textTheme.bodyMedium?.copyWith(
                                                          color: colorScheme.primary .withAlpha(128)
                                                        ),
                                                        border: InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                      style: textTheme.bodyMedium?.copyWith(
                                                        color: colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Card(
                                                  elevation: 0,
                                                  margin: EdgeInsets.zero,
                                                  color: colorScheme.surfaceBright,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(16.0),
                                                    child: Text(
                                                      "This is the Record card view.",
                                                      style: textTheme.bodyMedium
                                                      ?.copyWith(color: colorScheme.primary),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          OutlinedButton(
                                            onPressed: canContinue
                                                ? () {
                                              setState(() {
                                                if (completedPrompts < totalPrompts) completedPrompts += 1;
                                              });
                                            }: null, // doesnt do anything if disabled

                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: canContinue
                                                  ? colorScheme.primaryContainer
                                                  : colorScheme.surfaceContainerHighest,
                                              foregroundColor: canContinue
                                                  ? colorScheme.secondary
                                                  : colorScheme.onSurface.withAlpha(160),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              side: BorderSide(
                                                color: canContinue
                                                    ? Colors.transparent
                                                    : Colors.transparent,
                                                width: 1,
                                              ),
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            ),
                                            child: const Text("Continue", ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (completedPrompts > 0) completedPrompts -= 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: const Icon(Icons.arrow_back_ios_rounded),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (completedPrompts < 3) completedPrompts += 1;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: const Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }
}