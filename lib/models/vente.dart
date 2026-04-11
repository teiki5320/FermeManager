/// Vente d'un produit à un client.
class Vente {
  final String id;
  final String produit;
  final String client;
  final DateTime date;
  final double quantite;
  final String unite; // 'kg' | 'L' | 'unité'
  final double prixUnitaire; // en FCFA

  Vente({
    required this.id,
    required this.produit,
    required this.client,
    required this.date,
    required this.quantite,
    required this.unite,
    required this.prixUnitaire,
  });

  double get total => quantite * prixUnitaire;

  Map<String, dynamic> toJson() => {
        'id': id,
        'produit': produit,
        'client': client,
        'date': date.toIso8601String(),
        'quantite': quantite,
        'unite': unite,
        'prixUnitaire': prixUnitaire,
      };

  factory Vente.fromJson(Map<String, dynamic> json) => Vente(
        id: json['id'] as String,
        produit: json['produit'] as String,
        client: json['client'] as String,
        date: DateTime.parse(json['date'] as String),
        quantite: (json['quantite'] as num).toDouble(),
        unite: json['unite'] as String,
        prixUnitaire: (json['prixUnitaire'] as num).toDouble(),
      );
}
