import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/RecordingCard.dart';
import 'package:beebetter/pages/GuidedMode/RecordingLogic.dart';

class PromptCard extends StatefulWidget {
  final String category;
  final String prompt;
  final bool canContinue;
  final void Function(String) onContinuePressed;
  final void Function(String) onTextChanged;

  const PromptCard({
    super.key,
    required this.category,
    required this.prompt,
    required this.canContinue,
    required this.onContinuePressed,
    required this.onTextChanged,
  });

  @override
  State<PromptCard> createState() => PromptCardState();
}


class PromptCardState extends State<PromptCard>
    with AutomaticKeepAliveClientMixin{
  final TextEditingController controller = TextEditingController();


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
        child: Card(
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
                      widget.category,
                      style: textTheme.titleSmall
                          ?.copyWith(color: colorScheme.inversePrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ---------------------------------------------------
                  // Prompt
                  // ---------------------------------------------------
                  Text(widget.prompt, style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),),

                  const SizedBox(height: 8),

                  // ---------------------------------------------------
                  // Tabs
                  // ---------------------------------------------------
                  DefaultTabController(
                    length: 2,
                    child:
                    Expanded(
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceBright,
                              borderRadius: BorderRadius.circular(12),
                              // border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
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
                          ),

                          Expanded(
                            child:
                            TabBarView(
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
                                      controller: controller,
                                      onChanged: widget.onTextChanged,
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

                                ChangeNotifierProvider(
                                  create: (_) => RecordingLogic(),

                                  child: RecordingCard(),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // ---------------------------------------------------
                          // Continue Button
                          // ---------------------------------------------------
                          OutlinedButton(
                            onPressed: widget.canContinue ? () {
                              widget.onContinuePressed(controller.text.trim());
                            } : null,
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
                                  colors: widget.canContinue
                                      ? [
                                    colorScheme.inversePrimary,
                                    colorScheme.primaryContainer
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
                                    color: widget.canContinue
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
                    ), ),
                ]
            ),
          ),
        ),
      );
  }
}