/// Récolte effectuée sur une parcelle.
class Recolte {
  final String id;
  final String culture;
  final String parcelle;
  final DateTime date;
  final double quantiteKg;
  final String qualite; // 'A' | 'B' | 'C'
  final String note;

  Recolte({
    required this.id,
    required this.culture,
    required this.parcelle,
    required this.date,
    required this.quantiteKg,
    required this.qualite,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'culture': culture,
        'parcelle': parcelle,
        'date': date.toIso8601String(),
        'quantiteKg': quantiteKg,
        'qualite': qualite,
        'note': note,
      };

  factory Recolte.fromJson(Map<String, dynamic> json) => Recolte(
        id: json['id'] as String,
        culture: json['culture'] as String,
        parcelle: json['parcelle'] as String,
        date: DateTime.parse(json['date'] as String),
        quantiteKg: (json['quantiteKg'] as num).toDouble(),
        qualite: json['qualite'] as String,
        note: json['note'] as String? ?? '',
      );
}
