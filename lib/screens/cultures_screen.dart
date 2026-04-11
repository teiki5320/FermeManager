import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';
import '../widgets/module_verrouille.dart';

/// Écran "Cultures" — style pastel.
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
  final Color etatBgColor;

  const _Culture({
    required this.parcelle,
    required this.culture,
    required this.dateSemis,
    required this.stade,
    required this.progression,
    required this.dateRecolte,
    required this.etatSanitaire,
    required this.etatColor,
    required this.etatBgColor,
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
    etatBgColor: AppTheme.successSoft,
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
    etatBgColor: AppTheme.successSoft,
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
    etatBgColor: AppTheme.warningSoft,
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
    etatBgColor: AppTheme.successSoft,
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
              padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cultures',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Suivi des semis et de la croissance',
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
                      color: AppTheme.accent,
                      bgColor: AppTheme.accentSoft,
                      icon: Icons.eco,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      value: '$bonCount',
                      label: 'En bonne santé',
                      color: AppTheme.success,
                      bgColor: AppTheme.successSoft,
                      icon: Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      value: '$attentionCount',
                      label: 'Attention',
                      color: AppTheme.warning,
                      bgColor: AppTheme.warningSoft,
                      icon: Icons.warning_amber_rounded,
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
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : culture + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppTheme.accentDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        culture.culture,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        culture.parcelle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: culture.etatBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  culture.etatSanitaire,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: culture.etatColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progression
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
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
              const SizedBox(width: 12),
              SizedBox(
                width: 42,
                child: Text(
                  '${culture.progression}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.accentDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Détails
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Semis',
            value: culture.dateSemis,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.spa_outlined,
            label: 'Stade',
            value: culture.stade,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.event_available_outlined,
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
        Icon(icon, size: 15, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
