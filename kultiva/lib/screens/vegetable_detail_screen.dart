import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/regions/france.dart';
import '../data/regions/west_africa.dart';
import '../models/region_data.dart';
import '../models/vegetable.dart';
import '../services/prefs_service.dart';
import '../theme/app_theme.dart';

/// Fiche détail d'un légume — s'adapte à la région active pour les mois
/// de semis / récolte. Tous les champs optionnels sont affichés seulement
/// s'ils sont renseignés.
class VegetableDetailScreen extends StatelessWidget {
  final Vegetable vegetable;
  const VegetableDetailScreen({super.key, required this.vegetable});

  static const List<String> _shortMonths = <String>[
    'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc',
  ];

  List<RegionData> _dataFor(Region region) {
    switch (region) {
      case Region.france:
        return franceData;
      case Region.westAfrica:
        return westAfricaData;
    }
  }

  RegionData? _findRegionData(List<RegionData> list) {
    for (final d in list) {
      if (d.vegetableId == vegetable.id) return d;
    }
    return null;
  }

  Future<void> _openAmazon(BuildContext context) async {
    final url = vegetable.amazonUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible d'ouvrir le lien Amazon."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Region>(
      valueListenable: PrefsService.instance.region,
      builder: (context, region, _) {
        final data = _findRegionData(_dataFor(region));
        return Scaffold(
          appBar: AppBar(
            title: Text('${vegetable.emoji}  ${vegetable.name}'),
            actions: <Widget>[
              ValueListenableBuilder<Set<String>>(
                valueListenable: PrefsService.instance.favorites,
                builder: (context, favs, _) {
                  final isFav = favs.contains(vegetable.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: KultivaColors.terracotta,
                    ),
                    onPressed: () => PrefsService.instance
                        .toggleFavorite(vegetable.id),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            children: <Widget>[
              _HeaderCard(vegetable: vegetable),
              const SizedBox(height: 16),
              if (data != null && data.sowingMonths.isNotEmpty)
                _MonthsCard(
                  title: 'Semis — ${region.label}',
                  months: data.sowingMonths,
                  color: KultivaColors.primaryGreen,
                  shortMonths: _shortMonths,
                ),
              if (data != null && data.harvestMonths.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                _MonthsCard(
                  title: 'Récolte — ${region.label}',
                  months: data.harvestMonths,
                  color: KultivaColors.terracotta,
                  shortMonths: _shortMonths,
                ),
              ],
              const SizedBox(height: 16),
              _InfoSection(
                title: '🌱  Semis',
                rows: <_Row>[
                  _Row('Technique', vegetable.sowingTechnique),
                  _Row('Profondeur', vegetable.sowingDepth),
                  _Row('Température', vegetable.germinationTemp),
                  _Row('Levée', vegetable.germinationDays),
                ],
              ),
              _InfoSection(
                title: '🌿  Culture',
                rows: <_Row>[
                  _Row('Exposition', vegetable.exposure),
                  _Row('Espacement', vegetable.spacing),
                  _Row('Arrosage', vegetable.watering),
                  _Row('Sol', vegetable.soil),
                ],
              ),
              _InfoSection(
                title: '📦  Rendement',
                rows: <_Row>[
                  _Row('Estimation', vegetable.yieldEstimate),
                ],
              ),
              const SizedBox(height: 16),
              if (vegetable.amazonUrl != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openAmazon(context),
                    icon: const Text(
                      '🛒',
                      style: TextStyle(fontSize: 18),
                    ),
                    label: const Text('Acheter des graines'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KultivaColors.terracotta,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Vegetable vegetable;
  const _HeaderCard({required this.vegetable});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: KultivaColors.lightGreen.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    vegetable.emoji,
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        vegetable.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        vegetable.category.label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: KultivaColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (vegetable.description != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                vegetable.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthsCard extends StatelessWidget {
  final String title;
  final List<int> months;
  final Color color;
  final List<String> shortMonths;

  const _MonthsCard({
    required this.title,
    required this.months,
    required this.color,
    required this.shortMonths,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List<Widget>.generate(12, (i) {
                final m = i + 1;
                final active = months.contains(m);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: active
                                ? color
                                : color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shortMonths[i],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: active
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: active
                                ? color
                                : Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row {
  final String label;
  final String? value;
  const _Row(this.label, this.value);
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_Row> rows;
  const _InfoSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final filled = rows.where((r) => r.value != null).toList();
    if (filled.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              for (final r in filled)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 110,
                        child: Text(
                          r.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: KultivaColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          r.value!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
