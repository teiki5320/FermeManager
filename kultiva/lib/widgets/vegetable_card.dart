import 'package:flutter/material.dart';

import '../models/vegetable.dart';
import '../theme/app_theme.dart';

/// Card d'un légume — emoji, nom, note courte, badge "Semer" optionnel,
/// bouton favori optionnel.
class VegetableCard extends StatelessWidget {
  final Vegetable vegetable;
  final bool canSowNow;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const VegetableCard({
    super.key,
    required this.vegetable,
    this.canSowNow = false,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: KultivaColors.lightGreen.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  vegetable.emoji,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      vegetable.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vegetable.note ??
                          vegetable.description ??
                          vegetable.category.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (canSowNow)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: KultivaColors.primaryGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Semer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (onFavoriteToggle != null)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: KultivaColors.terracotta,
                  ),
                  onPressed: onFavoriteToggle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
