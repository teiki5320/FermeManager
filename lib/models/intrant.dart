/// Intrant en stock (engrais, semence, pesticide, etc.).
class Intrant {
  final String id;
  final String nom;
  final String type; // 'Engrais' | 'Semence' | 'Pesticide' | 'Autre'
  final double quantite;
  final String unite; // 'kg' | 'L' | 'unité'
  final double stockMinimum;
  final DateTime? datePeremption;

  Intrant({
    required this.id,
    required this.nom,
    required this.type,
    required this.quantite,
    required this.unite,
    required this.stockMinimum,
    this.datePeremption,
  });

  bool get enAlerte => quantite <= stockMinimum;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'type': type,
        'quantite': quantite,
        'unite': unite,
        'stockMinimum': stockMinimum,
        'datePeremption': datePeremption?.toIso8601String(),
      };

  factory Intrant.fromJson(Map<String, dynamic> json) => Intrant(
        id: json['id'] as String,
        nom: json['nom'] as String,
        type: json['type'] as String,
        quantite: (json['quantite'] as num).toDouble(),
        unite: json['unite'] as String,
        stockMinimum: (json['stockMinimum'] as num).toDouble(),
        datePeremption: json['datePeremption'] == null
            ? null
            : DateTime.parse(json['datePeremption'] as String),
      );
}
