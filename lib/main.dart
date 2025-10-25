import 'package:flutter/material.dart';
import 'package:beebetter/TodayPage.dart';
import 'package:beebetter/GuidedMode.dart';
import 'package:beebetter/Dashboard.dart';
import 'package:beebetter/ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
  int _selectedIndex = 0;

  final _pages = [
    Dashboard(),
    TodayPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.inversePrimary, spreadRadius: 0, blurRadius: 5),
              ],
            ),
            child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: BottomNavigationBar(
                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
                      unselectedItemColor: Theme.of(context).colorScheme.primary,
                      currentIndex: _selectedIndex,
                      // showSelectedLabels: false,
                      showUnselectedLabels: false,
                      onTap: _onItemTapped,
                      items:
                        <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(
                              context,
                              icon: Icons.today,
                              isSelected: _selectedIndex == 0,
                            ),
                            label: 'Dashboard',
                          ),
                          BottomNavigationBarItem(
                            icon: SizedBox.shrink(),
                            label: ' ',
                          ),
                          BottomNavigationBarItem(
                            icon: _buildNavIcon(
                              context,
                              icon: Icons.person,
                              isSelected: _selectedIndex == 2,
                            ),
                            label: 'Profile',
                          ),
                      ],
                    )
                  ),

                  Positioned(
                    top: -15, // Moves circle up to overlap
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.inversePrimary,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit_note,
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
              ]
            )
        )
    );
  }
}

Widget _buildNavIcon(BuildContext context,
    {required IconData icon, required bool isSelected}) {
  final colorScheme = Theme
      .of(context)
      .colorScheme;
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? colorScheme.onPrimary : Colors.transparent,
    ),
    child: Icon(
      icon,
      color: isSelected ? colorScheme.inversePrimary : colorScheme.primary,
      size: 28,
    ),
  );
}