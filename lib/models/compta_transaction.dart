enum ComptaType { revenu, depense }

/// Transaction comptable (revenu ou dépense).
class ComptaTransaction {
  final String id;
  final ComptaType type;
  final String categorie;
  final double montant; // en FCFA
  final DateTime date;
  final String description;

  ComptaTransaction({
    required this.id,
    required this.type,
    required this.categorie,
    required this.montant,
    required this.date,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'categorie': categorie,
        'montant': montant,
        'date': date.toIso8601String(),
        'description': description,
      };

  factory ComptaTransaction.fromJson(Map<String, dynamic> json) =>
      ComptaTransaction(
        id: json['id'] as String,
        type: ComptaType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ComptaType.depense,
        ),
        categorie: json['categorie'] as String,
        montant: (json['montant'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        description: json['description'] as String? ?? '',
      );
}
