import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';
import '../widgets/module_verrouille.dart';

/// Écran "Cultures" — port fidèle de app/(tabs)/cultures.tsx.
class CulturesScreen extends StatelessWidget {
  const CulturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ModulesProvider>();
    const content = _CulturesContent();

    if (!provider.isUnlocked(FarmModule.cultures)) {
      return ModuleVerrouille(
        moduleName: 'Cultures',
        prix: provider.priceOf(FarmModule.cultures),
        child: content,
      );
    }
    return content;
  }
}

class _Culture {
  final String parcelle;
  final String culture;
  final String dateSemis;
  final String stade;
  final int progression;
  final String dateRecolte;
  final String etatSanitaire;
  final Color etatColor;

  const _Culture({
    required this.parcelle,
    required this.culture,
    required this.dateSemis,
    required this.stade,
    required this.progression,
    required this.dateRecolte,
    required this.etatSanitaire,
    required this.etatColor,
  });
}

const List<_Culture> _cultures = [
  _Culture(
    parcelle: 'Parcelle A',
    culture: 'Pommes de terre',
    dateSemis: '15/02/2026',
    stade: 'Floraison',
    progression: 75,
    dateRecolte: '15/05/2026',
    etatSanitaire: 'Bon',
    etatColor: AppTheme.success,
  ),
  _Culture(
    parcelle: 'Parcelle B',
    culture: 'Carottes',
    dateSemis: '01/03/2026',
    stade: 'Croissance racinaire',
    progression: 55,
    dateRecolte: '01/06/2026',
    etatSanitaire: 'Bon',
    etatColor: AppTheme.success,
  ),
  _Culture(
    parcelle: 'Parcelle C',
    culture: 'Courgettes',
    dateSemis: '10/03/2026',
    stade: 'Fructification',
    progression: 65,
    dateRecolte: '20/05/2026',
    etatSanitaire: 'Attention',
    etatColor: AppTheme.warning,
  ),
  _Culture(
    parcelle: 'Parcelle D',
    culture: 'Tomates',
    dateSemis: '20/02/2026',
    stade: 'Maturation fruits',
    progression: 80,
    dateRecolte: '25/04/2026',
    etatSanitaire: 'Bon',
    etatColor: AppTheme.success,
  ),
];

class _CulturesContent extends StatelessWidget {
  const _CulturesContent();

  @override
  Widget build(BuildContext context) {
    final bonCount = _cultures.where((c) => c.etatSanitaire == 'Bon').length;
    final attentionCount =
        _cultures.where((c) => c.etatSanitaire == 'Attention').length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cultures',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Suivi semis et croissance',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Résumé
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      value: '${_cultures.length}',
                      label: 'Cultures',
                      labelColor: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      value: '$bonCount',
                      label: 'En bonne santé',
                      labelColor: AppTheme.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      value: '$attentionCount',
                      label: 'Attention',
                      labelColor: AppTheme.warning,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Liste
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  for (final c in _cultures) ...[
                    _CultureCard(culture: c),
                    const SizedBox(height: 12),
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

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final Color labelColor;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: labelColor),
          ),
        ],
      ),
    );
  }
}

class _CultureCard extends StatelessWidget {
  final _Culture culture;

  const _CultureCard({required this.culture});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : culture + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    culture.culture,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    culture.parcelle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: culture.etatColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  culture.etatSanitaire,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: culture.etatColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progression
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: culture.progression / 100,
                    minHeight: 8,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 40,
                child: Text(
                  '${culture.progression}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Détails
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Semis',
            value: culture.dateSemis,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.eco_outlined,
            label: 'Stade',
            value: culture.stade,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.check_circle_outline,
            label: 'Récolte prévue',
            value: culture.dateRecolte,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
