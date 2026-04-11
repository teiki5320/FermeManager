import '../../models/region_data.dart';

/// Données de semis et récolte pour la France métropolitaine.
///
/// Les mois sont indexés de 1 (janvier) à 12 (décembre).
const List<RegionData> franceData = <RegionData>[
  RegionData(
    regionId: 'france',
    vegetableId: 'tomate',
    sowingMonths: [2, 3, 4],
    harvestMonths: [7, 8, 9, 10],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'carotte',
    sowingMonths: [3, 4, 5, 6, 7],
    harvestMonths: [6, 7, 8, 9, 10, 11],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'courgette',
    sowingMonths: [4, 5, 6],
    harvestMonths: [7, 8, 9, 10],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'laitue',
    sowingMonths: [3, 4, 5, 6, 7, 8, 9],
    harvestMonths: [5, 6, 7, 8, 9, 10, 11],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'haricot',
    sowingMonths: [5, 6, 7],
    harvestMonths: [7, 8, 9, 10],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'aubergine',
    sowingMonths: [2, 3, 4],
    harvestMonths: [7, 8, 9, 10],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'poivron',
    sowingMonths: [2, 3, 4],
    harvestMonths: [7, 8, 9, 10],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'epinard',
    sowingMonths: [3, 4, 8, 9],
    harvestMonths: [5, 6, 10, 11],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'oignon',
    sowingMonths: [2, 3, 9, 10],
    harvestMonths: [6, 7, 8],
  ),
  RegionData(
    regionId: 'france',
    vegetableId: 'basilic',
    sowingMonths: [3, 4, 5, 6],
    harvestMonths: [6, 7, 8, 9],
  ),
];
