/// Évènement d'irrigation sur une parcelle.
class Irrigation {
  final String id;
  final String parcelle;
  final DateTime date;
  final double volumeM3; // en mètres cubes
  final String source; // 'Puits' | 'Forage' | 'Pluviale' | 'Réseau'
  final String note;

  Irrigation({
    required this.id,
    required this.parcelle,
    required this.date,
    required this.volumeM3,
    required this.source,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcelle': parcelle,
        'date': date.toIso8601String(),
        'volumeM3': volumeM3,
        'source': source,
        'note': note,
      };

  factory Irrigation.fromJson(Map<String, dynamic> json) => Irrigation(
        id: json['id'] as String,
        parcelle: json['parcelle'] as String,
        date: DateTime.parse(json['date'] as String),
        volumeM3: (json['volumeM3'] as num).toDouble(),
        source: json['source'] as String,
        note: json['note'] as String? ?? '',
      );
}
