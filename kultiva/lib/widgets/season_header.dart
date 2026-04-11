import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'petal_animation.dart';

/// En-tête illustré d'une saison — dégradé + illustration (si fournie)
/// + rideau de particules animées + libellé mois/saison.
class SeasonHeader extends StatelessWidget {
  final Season season;
  final int month;
  final double height;

  const SeasonHeader({
    super.key,
    required this.season,
    required this.month,
    this.height = 220,
  });

  static const List<String> _months = <String>[
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Fond : dégradé pastel (fallback si pas d'illustration).
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _seasonGradient(season),
                ),
              ),
            ),
            // Illustration kawaii : activée si présente dans assets/images/.
            Image.asset(
              season.assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            // Voile doux pour lisibilité du texte.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.white.withOpacity(0.0),
                    Colors.black.withOpacity(0.25),
                  ],
                ),
              ),
            ),
            // Particules animées.
            SeasonParticleAnimation(season: season),
            // Libellé.
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${season.emoji}  ${season.label}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: const <Shadow>[
                            Shadow(color: Colors.black38, blurRadius: 8),
                          ],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _months[month - 1],
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              shadows: const <Shadow>[
                                Shadow(color: Colors.black45, blurRadius: 10),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _seasonGradient(Season season) {
    switch (season) {
      case Season.spring:
        return const <Color>[KultivaColors.springA, KultivaColors.springB];
      case Season.summer:
        return const <Color>[KultivaColors.summerA, KultivaColors.summerB];
      case Season.autumn:
        return const <Color>[KultivaColors.autumnA, KultivaColors.autumnB];
      case Season.winter:
        return const <Color>[KultivaColors.winterA, KultivaColors.winterB];
    }
  }
}
