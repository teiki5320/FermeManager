# FermeManager (Flutter)

Application mobile de gestion de ferme, en Flutter.
Destinée aux exploitants agricoles qui veulent suivre irrigation,
cultures, intrants, récoltes, ventes et comptabilité depuis leur téléphone.

## Fonctionnalités

8 onglets :

- **Accueil** : vue d'ensemble, état des modules débloqués
- **Irrigation** : planification et suivi des arrosages (à dev)
- **Cultures** : suivi des semis, stades, progression, récolte prévue (✅ complet)
- **Intrants** : gestion des engrais et semences (à dev)
- **Récoltes** : suivi par parcelle (à dev)
- **Ventes** : chiffre d'affaires (à dev)
- **Comptabilité** : revenus, dépenses, bilans (à dev)
- **MAJ** : version et mises à jour

### Système de déblocage par code

Chaque module (hors Accueil et MAJ) est verrouillé en mode démo.
Pour débloquer, l'utilisateur peut :

1. Cliquer sur **Commander via WhatsApp** → envoie un message prérempli
2. Saisir un **code à 8 chiffres** fourni après paiement

Codes de test intégrés :
- `12345678` → Irrigation
- `23456789` → Cultures
- `34567890` → Intrants
- `45678901` → Récoltes
- `56789012` → Ventes
- `67890123` → Comptabilité
- `99999999` → Pack Complet (tout débloquer)

L'état débloqué est persisté avec `shared_preferences`.

## Stack

- **Flutter** >= 3.24 / **Dart** ^3.5
- `provider` — state management (ChangeNotifier)
- `shared_preferences` — persistance locale
- `url_launcher` — ouverture de WhatsApp

## Arborescence

```
lib/
├── main.dart
├── constants/
│   └── theme.dart                # Palette dark, AppTheme.dark
├── providers/
│   └── modules_provider.dart     # Déblocage + persistance
├── screens/
│   ├── root_tabs.dart            # BottomNavigationBar 8 onglets
│   ├── accueil_screen.dart
│   ├── irrigation_screen.dart
│   ├── cultures_screen.dart      # Implémenté en entier
│   ├── intrants_screen.dart
│   ├── recoltes_screen.dart
│   ├── ventes_screen.dart
│   ├── comptabilite_screen.dart
│   └── mises_a_jour_screen.dart
└── widgets/
    ├── module_verrouille.dart    # Wrap + bandeau + zone déblocage
    └── module_placeholder_screen.dart
```

## Démarrer

```bash
# Générer les dossiers natifs (android/, ios/, macos/, web/, etc.)
flutter create . --project-name ferme_manager

# Installer les dépendances
flutter pub get

# Lancer
flutter run
```

> ⚠️ Avant de lancer `flutter create .`, vérifie bien que tu es dans
> le dossier du projet (pas dans ton home `~`). Sinon tu vas polluer
> ton répertoire personnel avec les dossiers `android/`, `ios/`, etc.

## À faire

- Porter les modules Irrigation, Intrants, Récoltes, Ventes, Comptabilité
- Remplacer le numéro WhatsApp dans `widgets/module_verrouille.dart`
  (chercher `33XXXXXXXXX`)
- Ajouter des tests widget
