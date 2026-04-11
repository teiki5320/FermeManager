import 'package:flutter/material.dart';

import '../providers/modules_provider.dart';
import '../widgets/module_placeholder_screen.dart';

class RecoltesScreen extends StatelessWidget {
  const RecoltesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      module: FarmModule.recoltes,
      title: 'Récoltes',
      subtitle: 'Suivi des récoltes par parcelle',
      icon: Icons.shopping_basket,
    );
  }
}
