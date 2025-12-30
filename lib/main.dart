import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/MainPage/MainPage.dart';
import 'package:beebetter/pages/Onboarding/OnboardingPage.dart';
import 'package:beebetter/pages/Onboarding/OnboardingLogic.dart';
import 'package:beebetter/services/onboarding_service.dart';
import 'package:beebetter/services/profile_manager.dart';
import 'package:beebetter/services/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize theme manager
  await ThemeManager.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ThemeManager.instance,
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            title: 'BeeBetter',
            theme: ThemeManager.getLightTheme(),
            darkTheme: ThemeManager.getDarkTheme(),
            themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AppEntryPoint(),
          );
        },
      ),
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Initialize profile manager
    await ProfileManager.instance.initialize();
    
    // Check if onboarding is completed
    final isCompleted = await OnboardingService.isOnboardingCompleted();
    
    if (mounted) {
      setState(() {
        _showOnboarding = !isCompleted;
        _isLoading = false;
      });
    }
  }

  void _onOnboardingComplete() {
    if (mounted) {
      setState(() {
        _showOnboarding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingPageWrapper(onComplete: _onOnboardingComplete);
    }

    return const MainPage();
  }
}

class OnboardingPageWrapper extends StatefulWidget {
  final VoidCallback onComplete;
  
  const OnboardingPageWrapper({super.key, required this.onComplete});

  @override
  State<OnboardingPageWrapper> createState() => _OnboardingPageWrapperState();
}

class _OnboardingPageWrapperState extends State<OnboardingPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingLogic(),
      child: Consumer<OnboardingLogic>(
        builder: (context, logic, _) {
          // Listen for completion
          if (logic.isCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onComplete();
            });
          }
          return OnboardingPage();
        },
      ),
    );
  }
}
