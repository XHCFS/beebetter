import 'package:flutter/material.dart';
import 'package:beebetter/pages/TodayPage.dart';
import 'package:beebetter/pages/GuidedMode.dart';
import 'package:beebetter/pages/Dashboard.dart';
import 'package:beebetter/pages/ProfilePage.dart';
import 'widgets/Hexagon.dart';
import 'dart:math';


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

class _MainPageState extends State<MainPage> {
  int selectedIndex = 1;

  final _pages = [
    Dashboard(),
    TodayPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _pages[selectedIndex],
      ),
      bottomNavigationBar:  Container(
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
              height: 80,
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
            child: NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.today_outlined),
                      selectedIcon: Icon(Icons.today),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: 'Today',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                // ),
              ),
            ),
          ),
        ),
    );

  }
}

