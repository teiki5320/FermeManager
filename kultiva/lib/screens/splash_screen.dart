import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KultivaColors.lightBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: KultivaColors.lightGreen.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: KultivaColors.primaryGreen.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🌱', style: TextStyle(fontSize: 80)),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Kultiva',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: KultivaColors.primaryGreen,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Calendrier de semis',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: KultivaColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
