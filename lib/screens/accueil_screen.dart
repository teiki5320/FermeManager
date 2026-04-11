import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';

/// Écran d'accueil — liste des modules disponibles avec leur statut.
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ModulesProvider>();
    final unlockedCount =
        FarmModule.values.where(provider.isUnlocked).length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FermeManager',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Gérez votre exploitation facilement',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppTheme.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.agriculture,
                        color: AppTheme.accent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$unlockedCount / ${FarmModule.values.length} modules actifs',
                            style: const TextStyle(
                              color: AppTheme.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Débloquez davantage de fonctionnalités',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: const Text(
                'Modules',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
        return Icons.water_drop;
      case FarmModule.cultures:
        return Icons.eco;
      case FarmModule.intrants:
        return Icons.science;
      case FarmModule.recoltes:
        return Icons.shopping_basket;
      case FarmModule.ventes:
        return Icons.shopping_cart;
      case FarmModule.comptabilite:
        return Icons.calculate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // ignore: deprecated_member_use
          color: unlocked
              ? AppTheme.success.withOpacity(0.4)
              : AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Icon(_icon, color: AppTheme.accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  unlocked ? 'Débloqué' : price,
                  style: TextStyle(
                    color: unlocked
                        ? AppTheme.success
                        : AppTheme.textSecondary,
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
