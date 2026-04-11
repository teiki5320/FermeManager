import 'package:flutter/material.dart';

import '../providers/modules_provider.dart';
import '../widgets/module_placeholder_screen.dart';

class IntrantsScreen extends StatelessWidget {
  const IntrantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      module: FarmModule.intrants,
      title: 'Intrants',
      subtitle: 'Gestion des engrais et semences',
      icon: Icons.science,
    );
  }
}
