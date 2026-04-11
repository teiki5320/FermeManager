/// Région active pour l'affichage des calendriers de semis / récolte.
///
/// Extensible — pour ajouter une nouvelle région, ajoute une valeur d'enum
/// et crée le fichier correspondant dans `lib/data/regions/`.
enum Region {
  france('france', 'France', '🇫🇷'),
  westAfrica('west_africa', "Afrique de l'Ouest", '🌍');

  final String id;
  final String label;
  final String emoji;

  const Region(this.id, this.label, this.emoji);

  static Region fromId(String? id) {
    if (id == null) return Region.france;
    for (final r in Region.values) {
      if (r.id == id) return r;
    }
    return Region.france;
  }
}

/// Données de semis et récolte pour un légume dans une région donnée.
///
/// Les listes [sowingMonths] et [harvestMonths] contiennent des numéros de
/// mois entre 1 (janvier) et 12 (décembre).
class RegionData {
  final String regionId;
  final String vegetableId;
  final List<int> sowingMonths;
  final List<int> harvestMonths;

  const RegionData({
    required this.regionId,
    required this.vegetableId,
    required this.sowingMonths,
    required this.harvestMonths,
  });
}
