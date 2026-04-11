/// Modèle d'une culture sur une parcelle.
class Culture {
  final String id;
  final String parcelle;
  final String nom;
  final DateTime dateSemis;
  final String stade;
  final int progression; // 0-100
  final DateTime dateRecoltePrevue;
  final String etatSanitaire; // 'Bon' | 'Attention' | 'Critique'

  Culture({
    required this.id,
    required this.parcelle,
    required this.nom,
    required this.dateSemis,
    required this.stade,
    required this.progression,
    required this.dateRecoltePrevue,
    required this.etatSanitaire,
  });

  Culture copyWith({
    String? parcelle,
    String? nom,
    DateTime? dateSemis,
    String? stade,
    int? progression,
    DateTime? dateRecoltePrevue,
    String? etatSanitaire,
  }) {
    return Culture(
      id: id,
      parcelle: parcelle ?? this.parcelle,
      nom: nom ?? this.nom,
      dateSemis: dateSemis ?? this.dateSemis,
      stade: stade ?? this.stade,
      progression: progression ?? this.progression,
      dateRecoltePrevue: dateRecoltePrevue ?? this.dateRecoltePrevue,
      etatSanitaire: etatSanitaire ?? this.etatSanitaire,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcelle': parcelle,
        'nom': nom,
        'dateSemis': dateSemis.toIso8601String(),
        'stade': stade,
        'progression': progression,
        'dateRecoltePrevue': dateRecoltePrevue.toIso8601String(),
        'etatSanitaire': etatSanitaire,
      };

  factory Culture.fromJson(Map<String, dynamic> json) => Culture(
        id: json['id'] as String,
        parcelle: json['parcelle'] as String,
        nom: json['nom'] as String,
        dateSemis: DateTime.parse(json['dateSemis'] as String),
        stade: json['stade'] as String,
        progression: (json['progression'] as num).toInt(),
        dateRecoltePrevue:
            DateTime.parse(json['dateRecoltePrevue'] as String),
        etatSanitaire: json['etatSanitaire'] as String,
      );
}
