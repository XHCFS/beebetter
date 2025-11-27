import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/MainPage/MainPageLogic.dart';

class NavigationBarWidget extends StatelessWidget {
  final double navBarHeight;
  const NavigationBarWidget({required this.navBarHeight});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<MainPageLogic>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border.all(
          color: colorScheme.outline.withAlpha(77),
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
            backgroundColor: colorScheme.surface,
            indicatorColor: colorScheme.inversePrimary.withAlpha(64),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,

            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: colorScheme.primary,
                  size: 30,
                );
              }
              return IconThemeData(
                color: colorScheme.primary.withAlpha(128),
                size: 30,
              );
            }),

            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                );
              }
              return TextStyle(
                fontSize: 12,
                color: colorScheme.primary.withAlpha(128),
              );
            }),
          ),
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: NavigationBar(
              selectedIndex: logic.selectedIndex,
              onDestinationSelected: logic.onItemTapped,
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
    );
  }
}
