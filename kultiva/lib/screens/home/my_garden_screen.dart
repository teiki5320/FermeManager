import 'package:flutter/material.dart';

import '../../data/vegetables_base.dart';
import '../../models/vegetable.dart';
import '../../services/prefs_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/vegetable_card.dart';
import '../vegetable_detail_screen.dart';

/// Onglet "Mon Jardin" — liste des légumes marqués favoris ❤️.
class MyGardenScreen extends StatelessWidget {
  const MyGardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          AppBar(title: const Text('Mon Jardin')),
          Expanded(
            child: ValueListenableBuilder<Set<String>>(
              valueListenable: PrefsService.instance.favorites,
              builder: (context, favs, _) {
                final favorites = vegetablesBase
                    .where((v) => favs.contains(v.id))
                    .toList()
                  ..sort((a, b) => a.name.compareTo(b.name));
                if (favorites.isEmpty) {
                  return const _EmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final v = favorites[index];
                    return VegetableCard(
                      vegetable: v,
                      isFavorite: true,
                      onFavoriteToggle: () =>
                          PrefsService.instance.toggleFavorite(v.id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              VegetableDetailScreen(vegetable: v),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: KultivaColors.lightGreen.withOpacity(0.35),
                borderRadius: BorderRadius.circular(36),
              ),
              alignment: Alignment.center,
              child: const Text('❤️', style: TextStyle(fontSize: 70)),
            ),
            const SizedBox(height: 24),
            Text(
              "Ton jardin est vide",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ajoutez vos légumes préférés ❤️ depuis l'onglet Légumes.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KultivaColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
