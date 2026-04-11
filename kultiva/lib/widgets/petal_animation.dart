import 'dart:math';

import 'package:flutter/material.dart';

/// Saison en cours — déduite du mois courant.
enum Season {
  spring,
  summer,
  autumn,
  winter;

  /// Calcule la saison à partir d'un numéro de mois (1-12).
  static Season fromMonth(int month) {
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  String get label {
    switch (this) {
      case Season.spring:
        return 'Printemps';
      case Season.summer:
        return 'Été';
      case Season.autumn:
        return 'Automne';
      case Season.winter:
        return 'Hiver';
    }
  }

  String get emoji {
    switch (this) {
      case Season.spring:
        return '🌸';
      case Season.summer:
        return '☀️';
      case Season.autumn:
        return '🍂';
      case Season.winter:
        return '❄️';
    }
  }

  /// Symboles animés superposés à l'illustration de saison.
  List<String> get particles {
    switch (this) {
      case Season.spring:
        return const ['🌸', '🌸', '🌸', '🌼'];
      case Season.summer:
        return const ['🦋', '🦋', '✨', '✨'];
      case Season.autumn:
        return const ['🍂', '🍁', '🍂'];
      case Season.winter:
        return const ['❄️', '❄️', '❄️', '❅'];
    }
  }

  /// Chemin de l'illustration kawaii dans le bundle d'assets.
  ///
  /// Si le fichier n'est pas fourni, [SeasonHeader] retombe automatiquement
  /// sur un dégradé pastel correspondant à la saison.
  String get assetPath {
    switch (this) {
      case Season.spring:
        return 'assets/images/spring.png';
      case Season.summer:
        return 'assets/images/summer.png';
      case Season.autumn:
        return 'assets/images/autumn.png';
      case Season.winter:
        return 'assets/images/winter.png';
    }
  }
}

/// Rideau de particules animées (pétales, papillons, feuilles, flocons)
/// superposé à l'illustration saisonnière.
class SeasonParticleAnimation extends StatefulWidget {
  final Season season;
  final int count;

  const SeasonParticleAnimation({
    super.key,
    required this.season,
    this.count = 22,
  });

  @override
  State<SeasonParticleAnimation> createState() =>
      _SeasonParticleAnimationState();
}

class _SeasonParticleAnimationState extends State<SeasonParticleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random(42);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _particles = _createParticles();
  }

  @override
  void didUpdateWidget(covariant SeasonParticleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.season != widget.season ||
        oldWidget.count != widget.count) {
      setState(() => _particles = _createParticles());
    }
  }

  List<_Particle> _createParticles() {
    final symbols = widget.season.particles;
    return List<_Particle>.generate(widget.count, (i) {
      return _Particle(
        symbol: symbols[_random.nextInt(symbols.length)],
        startX: _random.nextDouble(),
        startY: _random.nextDouble(),
        speed: 0.3 + _random.nextDouble() * 0.7,
        drift: (_random.nextDouble() - 0.5) * 0.4,
        size: 14 + _random.nextDouble() * 16,
        phase: _random.nextDouble(),
        rotation: (_random.nextDouble() - 0.5) * pi,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: <Widget>[
                  for (final p in _particles)
                    _buildParticle(p, constraints),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildParticle(_Particle p, BoxConstraints c) {
    final t = (_controller.value + p.phase) % 1.0;
    final dx = (p.startX + p.drift * t + 1.0) % 1.0;
    double dy;
    switch (widget.season) {
      case Season.summer:
        // Papillons : vol en sinusoïde autour du point d'origine.
        dy = (p.startY + sin((t + p.phase) * 2 * pi) * 0.15 + 1.0) % 1.0;
        break;
      case Season.spring:
      case Season.autumn:
      case Season.winter:
        // Chute régulière du haut vers le bas.
        dy = (p.startY + t * p.speed) % 1.0;
        break;
    }

    final w = c.maxWidth;
    final h = c.maxHeight;
    final angle = p.rotation + t * 2 * pi * 0.2;
    return Positioned(
      left: dx * w - p.size / 2,
      top: dy * h - p.size / 2,
      child: Transform.rotate(
        angle: angle,
        child: Opacity(
          opacity: 0.85,
          child: Text(
            p.symbol,
            style: TextStyle(fontSize: p.size),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final String symbol;
  final double startX;
  final double startY;
  final double speed;
  final double drift;
  final double size;
  final double phase;
  final double rotation;

  const _Particle({
    required this.symbol,
    required this.startX,
    required this.startY,
    required this.speed,
    required this.drift,
    required this.size,
    required this.phase,
    required this.rotation,
  });
}
