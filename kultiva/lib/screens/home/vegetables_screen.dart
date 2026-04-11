import 'package:flutter/material.dart';

import '../../data/vegetables_base.dart';
import '../../models/vegetable.dart';
import '../../services/prefs_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/vegetable_card.dart';
import '../vegetable_detail_screen.dart';

/// Onglet "Légumes" — catalogue complet avec recherche et filtre par
/// catégorie.
class VegetablesScreen extends StatefulWidget {
  const VegetablesScreen({super.key});

  @override
  State<VegetablesScreen> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  VegetableCategory? _selectedCategory;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = vegetablesBase.where((v) {
      if (_selectedCategory != null && v.category != _selectedCategory) {
        return false;
      }
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        return v.name.toLowerCase().contains(q) ||
            (v.description?.toLowerCase().contains(q) ?? false);
      }
      return true;
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Légumes'),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'Rechercher un légume…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                _CategoryChip(
                  label: 'Toutes',
                  emoji: '✨',
                  selected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                for (final cat in VegetableCategory.values)
                  _CategoryChip(
                    label: cat.label,
                    emoji: cat.emoji,
                    selected: _selectedCategory == cat,
                    onTap: () => setState(
                      () => _selectedCategory =
                          _selectedCategory == cat ? null : cat,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        "Aucun légume ne correspond à ta recherche.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: KultivaColors.textSecondary,
                            ),
                      ),
                    ),
                  )
                : ValueListenableBuilder<Set<String>>(
                    valueListenable: PrefsService.instance.favorites,
                    builder: (context, favs, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final v = filtered[index];
                          return VegetableCard(
                            vegetable: v,
                            isFavorite: favs.contains(v.id),
                            onFavoriteToggle: () => PrefsService.instance
                                .toggleFavorite(v.id),
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text('$emoji  $label'),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
