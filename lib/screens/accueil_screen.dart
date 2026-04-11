import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';

/// Écran d'accueil — dashboard des modules, style pastel.
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ModulesProvider>();
    final unlockedCount =
        FarmModule.values.where(provider.isUnlocked).length;
    final total = FarmModule.values.length;
    final progress = total == 0 ? 0.0 : unlockedCount / total;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                'Bonjour 👋',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'FermeManager',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Carte résumé modules
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.agriculture,
                            color: AppTheme.accentDark,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$unlockedCount / $total modules actifs',
                                style: const TextStyle(
                                  color: AppTheme.accentDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Débloquez plus de fonctionnalités',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 26, 20, 12),
              child: Text(
                'Modules',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final module in FarmModule.values) ...[
                    _ModuleTile(
                      module: module,
                      unlocked: provider.isUnlocked(module),
                      label: provider.labelOf(module),
                      price: provider.priceOf(module),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final FarmModule module;
  final bool unlocked;
  final String label;
  final String price;

  const _ModuleTile({
    required this.module,
    required this.unlocked,
    required this.label,
    required this.price,
  });

  IconData get _icon {
    switch (module) {
      case FarmModule.irrigation:
        return Icons.water_drop_outlined;
      case FarmModule.cultures:
        return Icons.eco_outlined;
      case FarmModule.intrants:
        return Icons.science_outlined;
      case FarmModule.recoltes:
        return Icons.shopping_basket_outlined;
      case FarmModule.ventes:
        return Icons.shopping_cart_outlined;
      case FarmModule.comptabilite:
        return Icons.calculate_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? AppTheme.successSoft : AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _icon,
              color: unlocked ? AppTheme.success : AppTheme.accentDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  unlocked ? 'Débloqué' : price,
                  style: TextStyle(
                    color:
                        unlocked ? AppTheme.success : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            unlocked ? Icons.check_circle : Icons.lock_outline,
            color: unlocked ? AppTheme.success : AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
