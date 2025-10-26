import 'package:flutter/material.dart';
import 'package:beebetter/TodayPage.dart';
import 'package:beebetter/GuidedMode.dart';
import 'package:beebetter/Dashboard.dart';
import 'package:beebetter/ProfilePage.dart';
import 'widgets/Hexagon.dart';
import 'dart:math';


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
    final hexWidth = 90.0;
    final hexHeight = hexWidth * sqrt(3) / 2;

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
                      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
                      unselectedItemColor: Theme.of(context).colorScheme.primary,
                      currentIndex: _selectedIndex,
                      // showSelectedLabels: false,
                      showUnselectedLabels: false,
                      onTap: _onItemTapped,
                      items:
                        <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.today,),
                            label: 'Dashboard',
                          ),
                          BottomNavigationBarItem(
                            icon: SizedBox.shrink(),
                            label: ' ',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person,),
                            label: 'Profile',
                          ),
                      ],
                    )
                  ),

                  Positioned(
                    top: -25,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                        ClipPath(
                          clipper: HexagonClipper(),
                          child: Container(
                            width: hexWidth,
                            height: hexHeight,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),

                        ClipPath(
                          clipper: HexagonClipper(),
                          child: Container(
                            width: hexWidth * 0.92,
                            height: hexHeight * 0.92,
                            color: Theme.of(context).colorScheme.surface,
                            child: Icon(Icons.edit_note,
                                color: _selectedIndex == 1?
                                Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.primary
                                , size: 50),
                            ),
                          ),
                        ],
                        )
                      ),
                    ),
              ]
            )
        )
    );
  }
}
