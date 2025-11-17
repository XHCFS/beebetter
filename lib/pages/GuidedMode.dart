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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // top & horizontal padding
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
  int currentPrompt = 1;
  int completedPrompts = 1;
  String promptCategory = "productivity";
  String prompt = "What's one small win you had today?";
  bool canContinue = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
          children: [
            // ---------------------------------------------------
            // Swipe Gesture Indication Bar
            // ---------------------------------------------------
            Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
          child:
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_back),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // const SizedBox(height: 4),
                  Center(
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text("Daily Prompts", style: textTheme.titleLarge
                                    ?.copyWith(color: colorScheme.primary),),
                                const SizedBox(height: 16),

                                // ---------------------------------------------------
                                // Progress bar
                                // ---------------------------------------------------
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
                                      backgroundColor: colorScheme.primary.withAlpha(30),
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
                                    shadowColor: colorScheme.inversePrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        // side: BorderSide(color: colorScheme.inversePrimary.withAlpha(80), width: 1)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // ---------------------------------------------------
                                          // Category
                                          // ---------------------------------------------------
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
                                          // ---------------------------------------------------
                                          Text("$prompt", style: textTheme.titleMedium
                                              ?.copyWith(color: colorScheme.primary),),
                                          // const SizedBox(height: 4),

                                          // ---------------------------------------------------
                                          // Tabs
                                          // ---------------------------------------------------
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
                                                          // side: BorderSide(color: colorScheme.inversePrimary.withAlpha(120), width: 2)
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(16.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets.all(16),
                                                                child: Icon(
                                                                  Icons.mic,
                                                                  size: 32,
                                                                  color: Theme.of(context).colorScheme.primary,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16),
                                                              Text("Click to start", style: textTheme.bodyMedium
                                                                  ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                                                            ],
                                                          ),
                                                        //   child: Text(
                                                        //     "This is the Record card view.",
                                                        //     style: textTheme.bodyMedium
                                                        //     ?.copyWith(color: colorScheme.primary),),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                // ---------------------------------------------------
                                                // Continue Button
                                                // ---------------------------------------------------
                                                OutlinedButton(
                                                  onPressed: canContinue
                                                      ? () {
                                                    setState(() {
                                                      if (completedPrompts < totalPrompts) completedPrompts += 1;
                                                    });
                                                  }
                                                      : null,
                                                  style: OutlinedButton.styleFrom(
                                                    padding: EdgeInsets.zero, // important to remove default padding
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    side: BorderSide.none,
                                                  ),
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: canContinue
                                                            ? [
                                                          colorScheme.inversePrimary,
                                                          colorScheme.errorContainer,
                                                        ]
                                                            : [
                                                          colorScheme.surfaceContainerHighest,
                                                          colorScheme.surfaceContainerHighest,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                      child: Text(
                                                        "Continue",
                                                        style: TextStyle(
                                                          color: canContinue
                                                              ? colorScheme.secondary
                                                              : colorScheme.onSurface.withAlpha(160),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 32),
                                // ---------------------------------------------------
                                // Navigation Buttons
                                // ---------------------------------------------------
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Back
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (currentPrompt > 1) currentPrompt -= 1;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentPrompt <= 1
                                            ? colorScheme.inversePrimary.withAlpha(100)
                                            : colorScheme.inversePrimary,
                                        foregroundColor: colorScheme.surface,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(Icons.arrow_back_ios_rounded),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("$currentPrompt / $totalPrompts", style: textTheme.bodyLarge
                                            ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
                                        const SizedBox(width: 4),
                                        Material(
                                          color: Colors.transparent,
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              setState(() {

                                              });
                                            },
                                            splashColor: colorScheme.primary.withOpacity(0.2),
                                            highlightColor: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.shuffle_rounded,
                                                color: colorScheme.primary.withAlpha(160),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ],
                                    ),
                                    // Next
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (currentPrompt < 3) currentPrompt += 1;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: currentPrompt >= 3
                                            ? colorScheme.inversePrimary.withAlpha(100)
                                            : colorScheme.inversePrimary,
                                        foregroundColor: colorScheme.surface,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                  ],
                                )
                                // ---------------------------------------------------
                              ],
                            ),
                      ]
                    ),
                  ),
                ]
              ),
            ),
          ),
        ]
    );
  }
}