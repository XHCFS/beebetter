import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Onboarding/OnboardingLogic.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingLogic(),
      child: Scaffold(
        body: BackgroundGradient(
          body: OnboardingContent(),
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<OnboardingLogic>();

    return SafeArea(
      child: PageView(
        controller: logic.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Step 1: Welcome
          _WelcomeStep(logic: logic),
          // Step 2: Profile Setup
          _ProfileSetupStep(logic: logic),
          // Step 3: Complete
          _CompleteStep(logic: logic),
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final OnboardingLogic logic;
  const _WelcomeStep({required this.logic});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.auto_awesome_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            "Welcome to BeeBetter",
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            "Your personal journaling companion to track your thoughts, emotions, and growth journey.",
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary.withAlpha(200),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Features
          _FeatureItem(
            icon: Symbols.edit_note_rounded,
            text: "Write or record your thoughts",
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            icon: Symbols.insights_rounded,
            text: "Track your mood and emotions",
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            icon: Symbols.person_rounded,
            text: "Create multiple profiles",
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const Spacer(),
          // Next Button
          FilledButton(
            onPressed: () => logic.nextStep(),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Get Started",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ProfileSetupStep extends StatelessWidget {
  final OnboardingLogic logic;
  const _ProfileSetupStep({required this.logic});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.person_add_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            "Create Your Profile",
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            "Let's set up your profile. You can create multiple profiles later if needed.",
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary.withAlpha(200),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Name Input
          Card(
            color: colorScheme.onPrimary,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's your name?",
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: logic.nameController,
                    autofocus: true,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                        color: colorScheme.primary.withAlpha(128),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHigh,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withAlpha(128),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withAlpha(128),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (value) {
                      logic.updateName(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Create Profile Button
          FilledButton(
            onPressed: logic.canCreateProfile ? () => logic.createProfile() : null,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.primary.withAlpha(128),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: logic.isCreating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    "Create Profile",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CompleteStep extends StatelessWidget {
  final OnboardingLogic logic;
  const _CompleteStep({required this.logic});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.check_circle_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            "You're All Set!",
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            "Welcome to your journaling journey. Start by creating your first entry!",
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary.withAlpha(200),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Enter App Button
          FilledButton(
            onPressed: () => logic.completeOnboarding(),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Start Journaling",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.inversePrimary.withAlpha(40),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 24,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary.withAlpha(200),
            ),
          ),
        ),
      ],
    );
  }
}

