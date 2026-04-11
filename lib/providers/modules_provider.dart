import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Liste des modules payants de FermeManager.
enum FarmModule {
  irrigation,
  cultures,
  intrants,
  recoltes,
  ventes,
  comptabilite,
}

/// Résultat d'une tentative de déblocage.
class UnlockResult {
  final bool success;
  final String message;
  const UnlockResult({required this.success, required this.message});
}

/// Provider gérant l'état de déblocage des modules.
/// Port Dart de `hooks/useModules.ts` (React Native).
class ModulesProvider extends ChangeNotifier {
  static const String _storageKey = 'ferme_modules_unlocked';

  /// Codes de déblocage — mêmes valeurs que la version Expo.
  static const Map<String, String> _unlockCodes = {
    '12345678': 'irrigation',
    '23456789': 'cultures',
    '34567890': 'intrants',
    '45678901': 'recoltes',
    '56789012': 'ventes',
    '67890123': 'comptabilite',
    '99999999': 'pack_complet',
  };

  static const Map<FarmModule, String> modulePrices = {
    FarmModule.irrigation: '2 000 FCFA',
    FarmModule.cultures: '2 000 FCFA',
    FarmModule.intrants: '2 000 FCFA',
    FarmModule.recoltes: '2 000 FCFA',
    FarmModule.ventes: '3 000 FCFA',
    FarmModule.comptabilite: '3 000 FCFA',
  };

  static const Map<FarmModule, String> moduleLabels = {
    FarmModule.irrigation: 'Irrigation',
    FarmModule.cultures: 'Cultures',
    FarmModule.intrants: 'Intrants',
    FarmModule.recoltes: 'Récoltes',
    FarmModule.ventes: 'Ventes',
    FarmModule.comptabilite: 'Comptabilité',
  };

  final Map<FarmModule, bool> _unlocked = {
    for (final m in FarmModule.values) m: false,
  };

  bool _loading = true;
  bool get loading => _loading;

  Map<FarmModule, bool> get unlocked => Map.unmodifiable(_unlocked);

  bool isUnlocked(FarmModule module) => _unlocked[module] ?? false;
  String priceOf(FarmModule module) => modulePrices[module] ?? '';
  String labelOf(FarmModule module) => moduleLabels[module] ?? '';

  /// À appeler une fois au démarrage de l'app.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_storageKey);
      if (raw != null) {
        for (final name in raw) {
          final matching = FarmModule.values
              .where((m) => m.name == name)
              .toList();
          if (matching.isNotEmpty) {
            _unlocked[matching.first] = true;
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur chargement modules: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _unlocked.entries
        .where((e) => e.value)
        .map((e) => e.key.name)
        .toList();
    await prefs.setStringList(_storageKey, list);
  }

  /// Essaie de débloquer un module via un code à 8 chiffres.
  Future<UnlockResult> tryUnlock(String code) async {
    final target = _unlockCodes[code];
    if (target == null) {
      return const UnlockResult(
        success: false,
        message: 'Code invalide. Veuillez réessayer.',
      );
    }

    if (target == 'pack_complet') {
      for (final m in FarmModule.values) {
        _unlocked[m] = true;
      }
      await _persist();
      notifyListeners();
      return const UnlockResult(
        success: true,
        message: 'Pack Complet débloqué avec succès !',
      );
    }

    final matching =
        FarmModule.values.where((m) => m.name == target).toList();
    if (matching.isEmpty) {
      return const UnlockResult(
        success: false,
        message: 'Module inconnu.',
      );
    }
    final module = matching.first;
    _unlocked[module] = true;
    await _persist();
    notifyListeners();
    return UnlockResult(
      success: true,
      message: '${moduleLabels[module]} débloqué avec succès !',
    );
  }
}
