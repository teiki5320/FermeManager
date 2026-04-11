import 'package:flutter/material.dart';

import '../providers/modules_provider.dart';
import '../widgets/module_placeholder_screen.dart';

class VentesScreen extends StatelessWidget {
  const VentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      module: FarmModule.ventes,
      title: 'Ventes',
      subtitle: 'Suivi du chiffre d\'affaires',
      icon: Icons.shopping_cart,
    );
  }
}
