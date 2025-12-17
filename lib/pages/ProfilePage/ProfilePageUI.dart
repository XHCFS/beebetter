import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/ProfilePage/ProfilePageLogic.dart';

class ProfilePageUI extends StatelessWidget {
  const ProfilePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    final logic = context.read<ProfilePageLogic>();

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text("Profile & Settings", style: textTheme.headlineSmall
                ?.copyWith(color: colorScheme.primary),),
            Text("Manage your account and preferences", style: textTheme.titleMedium
                ?.copyWith(color: colorScheme.primary.withAlpha(160)),),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Personal Info
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
                      // ---------------------------------------------------
                      // Title
                      // ---------------------------------------------------
                      Text(
                        "Personal Information",
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // ---------------------------------------------------
                          // Icon
                          // ---------------------------------------------------
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.inversePrimary.withAlpha(40),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Symbols.person,
                              size: 32,
                              color: colorScheme.primary.withAlpha(240),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // ---------------------------------------------------
                          // Name & Age
                          // ---------------------------------------------------
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${logic.username}",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),

                              Text(
                                "Age: ${logic.age}",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Goals
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
                    // ---------------------------------------------------
                    // Title
                    // ---------------------------------------------------
                    Text(
                      "Your Goals",
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Areas you're focusing on in your journaling journey",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                    ),
                    const SizedBox(height: 16),
                    // ---------------------------------------------------
                    // Tags
                    // ---------------------------------------------------
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: logic.goals.map((goal) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceBright,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: colorScheme.inversePrimary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            goal,
                            style: textTheme.titleSmall
                                ?.copyWith(color: colorScheme.primary.withAlpha(200)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ]
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------------------------------
            // Account
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
                      // ---------------------------------------------------
                      // Title
                      // ---------------------------------------------------
                      Text(
                        "Account",
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ---------------------------------------------------
                          // Switch Account
                          // ---------------------------------------------------
                          FilledButton.icon(
                            onPressed: () {
                            },
                            icon: Icon(
                              Icons.swap_horiz,
                              size: 24,
                              color: colorScheme.primary.withAlpha(200),
                            ),
                            label: Text(
                              "Switch Account",
                              style: TextStyle(
                                color: colorScheme.primary.withAlpha(200),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              elevation: 0,
                              backgroundColor: colorScheme.secondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),
                          // ---------------------------------------------------
                          // Delete Data
                          // ---------------------------------------------------
                          SizedBox(
                            width: 48,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                elevation: 0,
                                backgroundColor: colorScheme.errorContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Icon(
                                Icons.delete_forever_outlined,
                                size: 24,
                                color: colorScheme.onErrorContainer.withAlpha(150),
                              ),
                            ),
                          ),

                        ]
                      ),
                      const SizedBox(height: 16),
                    ]
                ),
              ),
            ),
          ]
      ),
    );
  }
}