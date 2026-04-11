import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/info_card.dart';
import '../widgets/stat_card.dart';

/// Écran d'accueil — tableau de bord global.
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
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

            // Carte hero : bilan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  borderRadius: BorderRadius.circular(22),
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
                            Icons.account_balance_wallet,
                            color: AppTheme.accentDark,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bilan global',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Fmt.fcfa(state.bilanFcfa),
                        style: TextStyle(
                          color: state.bilanFcfa >= 0
                              ? AppTheme.accentDark
                              : AppTheme.error,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${Fmt.fcfa(state.totalRevenuFcfa)} entrées • ${Fmt.fcfa(state.totalDepenseFcfa)} sorties',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 26, 20, 12),
              child: Text(
                'Aperçu',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Grille 2x3 de stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.eco,
                          iconColor: AppTheme.accent,
                          iconBg: AppTheme.accentSoft,
                          value: '${state.cultures.length}',
                          label: 'Cultures',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.water_drop,
                          iconColor: AppTheme.secondary,
                          iconBg: AppTheme.secondarySoft,
                          value: '${state.irrigations.length}',
                          label: 'Arrosages',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.inventory_2,
                          iconColor: AppTheme.warning,
                          iconBg: AppTheme.warningSoft,
                          value: '${state.intrants.length}',
                          label: 'Intrants',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.shopping_basket,
                          iconColor: AppTheme.success,
                          iconBg: AppTheme.successSoft,
                          value: '${state.recoltes.length}',
                          label: 'Récoltes',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.shopping_cart,
                          iconColor: AppTheme.accent,
                          iconBg: AppTheme.accentSoft,
                          value: '${state.ventes.length}',
                          label: 'Ventes',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.receipt_long,
                          iconColor: AppTheme.secondary,
                          iconBg: AppTheme.secondarySoft,
                          value: '${state.compta.length}',
                          label: 'Comptes',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Alerte intrants
            if (state.intrantsEnAlerte > 0) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InfoCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.warningSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.warning,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.intrantsEnAlerte} intrant${state.intrantsEnAlerte > 1 ? "s" : ""} en alerte stock',
                              style: const TextStyle(
                                color: AppTheme.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Vérifie tes stocks dans l\'onglet Intrants',
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
            ],
          ],
        ),
      ),
    );
  }
}
