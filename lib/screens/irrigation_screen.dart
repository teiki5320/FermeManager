import 'package:flutter/material.dart';

import '../providers/modules_provider.dart';
import '../widgets/module_placeholder_screen.dart';

class IrrigationScreen extends StatelessWidget {
  const IrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      module: FarmModule.irrigation,
      title: 'Irrigation',
      subtitle: 'Planification et suivi des arrosages',
      icon: Icons.water_drop,
    );
  }
}
