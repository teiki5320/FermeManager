import 'package:flutter/material.dart';

import '../providers/modules_provider.dart';
import '../widgets/module_placeholder_screen.dart';

class ComptabiliteScreen extends StatelessWidget {
  const ComptabiliteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      module: FarmModule.comptabilite,
      title: 'Comptabilité',
      subtitle: 'Revenus, dépenses et bilans',
      icon: Icons.calculate,
    );
  }
}
