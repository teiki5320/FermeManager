import 'package:flutter/material.dart';

import 'home/my_garden_screen.dart';
import 'home/settings_screen.dart';
import 'home/sow_screen.dart';
import 'home/vegetables_screen.dart';

/// Conteneur des 4 onglets principaux de Kultiva.
class RootTabs extends StatefulWidget {
  final VoidCallback onSignOut;
  const RootTabs({super.key, required this.onSignOut});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const SowScreen(),
      const VegetablesScreen(),
      const MyGardenScreen(),
      SettingsScreen(onSignOut: widget.onSignOut),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            activeIcon: Icon(Icons.local_florist),
            label: 'Semer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Légumes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Mon Jardin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
