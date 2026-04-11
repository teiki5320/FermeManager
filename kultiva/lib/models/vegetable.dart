/// Catégorie d'un légume dans le catalogue Kultiva.
enum VegetableCategory {
  flowers,
  leaves,
  fruits,
  bulbs,
  tubers,
  seeds,
  roots,
  stems,
  aromatics;

  String get label {
    switch (this) {
      case VegetableCategory.flowers:
        return 'Fleurs';
      case VegetableCategory.leaves:
        return 'Feuilles';
      case VegetableCategory.fruits:
        return 'Fruits';
      case VegetableCategory.bulbs:
        return 'Bulbes';
      case VegetableCategory.tubers:
        return 'Tubercules';
      case VegetableCategory.seeds:
        return 'Graines';
      case VegetableCategory.roots:
        return 'Racines';
      case VegetableCategory.stems:
        return 'Tiges';
      case VegetableCategory.aromatics:
        return 'Aromatiques';
    }
  }

  String get emoji {
    switch (this) {
      case VegetableCategory.flowers:
        return '🌸';
      case VegetableCategory.leaves:
        return '🥬';
      case VegetableCategory.fruits:
        return '🍅';
      case VegetableCategory.bulbs:
        return '🧅';
      case VegetableCategory.tubers:
        return '🥔';
      case VegetableCategory.seeds:
        return '🫘';
      case VegetableCategory.roots:
        return '🥕';
      case VegetableCategory.stems:
        return '🌿';
      case VegetableCategory.aromatics:
        return '🌿';
    }
  }
}

/// Représente un légume du catalogue Kultiva.
///
/// Tous les champs sauf [id], [name], [emoji] et [category] sont optionnels —
/// ils s'affichent uniquement si renseignés dans la fiche détail.
class Vegetable {
  final String id;
  final String name;
  final String emoji;
  final VegetableCategory category;

  final String? description;

  /// Phrase courte affichée sur la card (liste "Semer"/"Légumes").
  final String? note;

  // --- Semis ---
  final String? sowingTechnique;
  final String? sowingDepth;
  final String? germinationTemp;
  final String? germinationDays;

  // --- Culture ---
  final String? exposure;
  final String? spacing;
  final String? watering;
  final String? soil;

  // --- Rendement ---
  final String? yieldEstimate;

  // --- Lien affilié ---
  final String? amazonUrl;

  const Vegetable({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    this.description,
    this.note,
    this.sowingTechnique,
    this.sowingDepth,
    this.germinationTemp,
    this.germinationDays,
    this.exposure,
    this.spacing,
    this.watering,
    this.soil,
    this.yieldEstimate,
    this.amazonUrl,
  });
}
