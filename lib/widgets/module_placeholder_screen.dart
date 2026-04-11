import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';
import 'module_verrouille.dart';

/// Écran placeholder pour les modules encore à développer.
/// Affiche un titre, un sous-titre, une icône, et verrouille le contenu
/// si le module n'est pas débloqué.
class ModulePlaceholderScreen extends StatelessWidget {
  final FarmModule module;
  final String title;
  final String subtitle;
  final IconData icon;

  const ModulePlaceholderScreen({
    super.key,
    required this.module,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ModulesProvider>();
    final content = _Content(title: title, subtitle: subtitle, icon: icon);

    if (!provider.isUnlocked(module)) {
      return ModuleVerrouille(
        moduleName: title,
        prix: provider.priceOf(module),
        child: content,
      );
    }
    return content;
  }
}

class _Content extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _Content({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 72, color: AppTheme.accent),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Écran à développer',
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Le contenu de ce module sera implémenté prochainement.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
