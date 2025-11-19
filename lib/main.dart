import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/TodayPage.dart';
import 'package:beebetter/pages/GuidedMode.dart';
import 'package:beebetter/pages/Dashboard.dart';
import 'package:beebetter/pages/ProfilePage.dart';
import 'dart:math';
import 'dart:ui';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final baseScheme = ColorScheme.fromSeed(seedColor: Colors.orangeAccent);
    // final customScheme = baseScheme.copyWith(
    //   primary: const Color(0xFF9C89B8),
    //   onPrimary: const Color(0xFFFFFFFF),
    //   secondary: const Color(0xFFBFA2DB),
    //   onSecondary: const Color(0xFF1C1B1F),
    //   tertiary: const Color(0xFFD9CFF3),
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      home: const MainPage(),
    );
  }
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  // ---------------------------------------------------
  // Sipe Up Guided Mode
  // ---------------------------------------------------
  late final AnimationController guidedModeController;

  @override
  void initState() {
    super.initState();
    guidedModeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 0,
    );
  }

  @override
  void dispose() {
    guidedModeController.dispose();
    super.dispose();
  }


  void openGuidedMode() => guidedModeController.forward();
  void closeGuidedMode() => guidedModeController.reverse();

  // ---------------------------------------------------
  // Navigation Bar Function
  // ---------------------------------------------------
  int selectedIndex = 1;
  final PageController pageController = PageController();

  List<Widget> get pages => [
    Dashboard(),
    TodayPage(openGuidedMode: openGuidedMode),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double navBarHeight = 40;
    return Scaffold(
      body: Stack(
        children: [
        // ---------------------------------------------------
        // Swipe Gesture Detector
        // ---------------------------------------------------
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (guidedModeController != null) {
                if (details.delta.dy < 0) { // upward drag
                  guidedModeController.value -= details.delta.dy / height;
                }
                if (details.delta.dy > 0) { // upward drag
                  guidedModeController.value -= details.delta.dy / height;
                }
              }
            },
            onVerticalDragEnd: (details) {
              if (guidedModeController.value < 0.15) {
                closeGuidedMode();   // snap closed
              } else {
                openGuidedMode();    // snap open
              }
            },
            // child: pages[selectedIndex],
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: pages,
              )

          ),
          // ---------------------------------------------------
          // Navigation Bar
          // ---------------------------------------------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
          child:
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child:  NavigationBarTheme(
                    data: NavigationBarThemeData(
                      height: navBarHeight,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      indicatorColor: Theme.of(context).colorScheme.inversePrimary.withAlpha(64),
                      // indicatorColor: Colors.transparent,
                      indicatorShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,

                      iconTheme: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return IconThemeData(
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          );
                        }
                        return IconThemeData(
                          color: Theme.of(context).colorScheme.primary.withAlpha(128),
                          size: 30,
                        );
                      }),

                      labelTextStyle: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          );
                        }
                        return TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary.withAlpha(128),
                        );
                      }),
                    ),
                    child: Transform.translate(
                    offset: const Offset(0, -6),
                      child: NavigationBar(
                        selectedIndex: selectedIndex,
                        onDestinationSelected: _onItemTapped,
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Symbols.today, fill: 0,),
                            selectedIcon: Icon(Symbols.today, fill: 1,),
                            label: 'Dashboard',
                          ),
                          NavigationDestination(
                            icon: Icon(Symbols.menu_book_rounded, fill: 0,),
                            selectedIcon: Icon(Symbols.menu_book_rounded, fill: 1,),
                            label: 'Today',
                          ),
                          NavigationDestination(
                            icon: Icon(Symbols.person, fill: 0,),
                            selectedIcon: Icon(Symbols.person, fill: 1,),
                            label: 'Profile',
                          ),
                        ],
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ---------------------------------------------------
          // Animation Builder for Swipe Animation
          // ---------------------------------------------------
          AnimatedBuilder(
            animation: guidedModeController,
            builder: (_, __) {
              final topPosition =
              lerpDouble(height, 0, guidedModeController.value)!;

              return Positioned(
                left: 0,
                right: 0,
                top: topPosition,
                height: height,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (guidedModeController != null) {
                      guidedModeController.value -= details.delta.dy / height;
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (guidedModeController.value < 0.8) {
                      closeGuidedMode();
                    } else {
                      openGuidedMode();
                    }
                  },
                  onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
                        closeGuidedMode();
                      }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.secondary.withAlpha(60),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      child: GuidedMode(),
                    ),
                  )
                ),
              );
            },
          ),

        ]
      ),
    );

  }
}

