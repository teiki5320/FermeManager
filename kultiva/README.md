# Kultiva

Calendrier de semis pour jardiniers — Flutter, style pastel kawaii japonais.

## Fonctionnalités

- 🌱 **Semer** — calendrier mensuel des légumes à semer
- 📖 **Légumes** — catalogue filtré par catégorie
- 🏡 **Mon Jardin** — liste des légumes favoris
- ⚙️ **Paramètres** — région, mode sombre, notifications

## Régions supportées

- 🇫🇷 France métropolitaine
- 🌍 Afrique de l'Ouest

La région active pilote toute l'application — mois de semis, mois de récolte et affichage des cards "À semer maintenant".

## Stack

- Flutter >= 3.24 / Dart ^3.5
- `google_fonts` — typographie Nunito
- `shared_preferences` — persistance locale
- `go_router` — navigation (dépendance prête, navigation principale en Navigator direct)
- `url_launcher` — liens affiliés Amazon
- `supabase_flutter` / `google_sign_in` / `sign_in_with_apple` — auth (stubs prêts à brancher)
- `flutter_local_notifications` — rappel mensuel (stub)

## Démarrer

```bash
cd kultiva
flutter create . --project-name kultiva
flutter pub get
flutter run
```

> La commande `flutter create .` génère les dossiers natifs (`android/`, `ios/`, `web/`, …) sans écraser `lib/` ni `pubspec.yaml`.

## Arborescence

```
lib/
├── main.dart
├── models/
│   ├── vegetable.dart
│   └── region_data.dart
├── data/
│   ├── vegetables_base.dart
│   └── regions/
│       ├── france.dart
│       └── west_africa.dart
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── root_tabs.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── sow_screen.dart
│   │   ├── vegetables_screen.dart
│   │   ├── my_garden_screen.dart
│   │   └── settings_screen.dart
│   └── vegetable_detail_screen.dart
├── widgets/
│   ├── season_header.dart
│   ├── vegetable_card.dart
│   └── petal_animation.dart
├── services/
│   ├── auth_service.dart
│   └── prefs_service.dart
└── theme/
    └── app_theme.dart
```

## Illustrations saisonnières

Place les quatre illustrations kawaii dans `assets/images/` :

| Saison      | Fichier        | Animation superposée                         |
| ----------- | -------------- | -------------------------------------------- |
| 🌸 Printemps | `spring.png`  | pétales qui tombent                          |
| ☀️ Été      | `summer.png`  | papillons qui voltigent + particules         |
| 🍂 Automne  | `autumn.png`  | feuilles qui tombent                         |
| ❄️ Hiver    | `winter.png`  | flocons de neige                             |

Puis décommente la section `assets:` dans `pubspec.yaml`.

Tant que les fichiers ne sont pas fournis, l'en-tête saisonnier s'affiche avec un dégradé pastel correspondant à la saison, et les animations se superposent normalement.

## Ajouter un légume

1. Ajoute l'entrée dans `lib/data/vegetables_base.dart` (un `const Vegetable(...)`).
2. Dans `lib/data/regions/france.dart` et `lib/data/regions/west_africa.dart`, ajoute un `RegionData` pour chaque région où le légume doit apparaître, avec les mois de semis et de récolte.

Tous les champs de la fiche légume sont optionnels — les sections vides sont automatiquement masquées dans la fiche détail.

## Auth

La v1 fournit un **AuthService en mode démo local** : les emails et mots de passe sont validés localement et la session est persistée via `SharedPreferences`. Pour brancher Supabase :

1. Initialise `Supabase.initialize(url: …, anonKey: …)` dans `main.dart`.
2. Remplace le corps de `lib/services/auth_service.dart` par des appels à `Supabase.instance.client.auth`.
3. Branche `google_sign_in` et `sign_in_with_apple` via `Supabase` OAuth.

## Géolocalisation (v2)

Non implémentée en v1 — la région se choisit manuellement. En v2, ajoute le package `geolocator` pour détecter la région au premier lancement.
