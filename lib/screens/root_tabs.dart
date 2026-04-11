import 'package:flutter/material.dart';

import '../constants/theme.dart';
import 'accueil_screen.dart';
import 'comptabilite_screen.dart';
import 'cultures_screen.dart';
import 'intrants_screen.dart';
import 'irrigation_screen.dart';
import 'mises_a_jour_screen.dart';
import 'recoltes_screen.dart';
import 'ventes_screen.dart';

/// Navigation principale : 8 onglets (Accueil + 6 modules + MAJ).
/// Équivalent Flutter de app/(tabs)/_layout.tsx.
class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;

  static const _screens = <Widget>[
    AccueilScreen(),
    IrrigationScreen(),
    CulturesScreen(),
    IntrantsScreen(),
    RecoltesScreen(),
    VentesScreen(),
    ComptabiliteScreen(),
    MisesAJourScreen(),
  ];

  static const _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
    BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Irrigation'),
    BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Cultures'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Intrants'),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_basket),
      label: 'Récoltes',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Ventes'),
    BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Comptes'),
    BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: 'MAJ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: _items,
        ),
      ),
    );
  }
}
