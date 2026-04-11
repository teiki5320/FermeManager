import 'package:flutter/material.dart';

import '../constants/theme.dart';

/// Carte blanche standardisée avec ombre douce et coins arrondis.
class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: child,
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      ),
    );
  }
}

/// Pastille colorée (ex: badge d'état "Bon", "Attention").
class ColoredPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const ColoredPill({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Bouton "+" flottant réutilisable.
class AddFab extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const AddFab({
    super.key,
    required this.onPressed,
    this.tooltip = 'Ajouter',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppTheme.accent,
      foregroundColor: Colors.white,
      elevation: 2,
      icon: const Icon(Icons.add),
      label: Text(
        tooltip,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
