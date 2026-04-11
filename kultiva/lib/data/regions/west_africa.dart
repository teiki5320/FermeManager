import '../../models/region_data.dart';

/// Données de semis et récolte pour l'Afrique de l'Ouest.
///
/// Saisons de référence :
///   - saison sèche : novembre → mai
///   - saison des pluies : juin → octobre
const List<RegionData> westAfricaData = <RegionData>[
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'tomate',
    sowingMonths: [10, 11, 12],
    harvestMonths: [1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'carotte',
    sowingMonths: [10, 11, 12, 1],
    harvestMonths: [1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'courgette',
    sowingMonths: [9, 10, 11],
    harvestMonths: [12, 1, 2],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'laitue',
    sowingMonths: [10, 11, 12, 1, 2],
    harvestMonths: [12, 1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'haricot',
    sowingMonths: [6, 7, 8, 10, 11],
    harvestMonths: [9, 10, 1, 2],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'aubergine',
    sowingMonths: [9, 10, 11],
    harvestMonths: [1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'poivron',
    sowingMonths: [9, 10, 11],
    harvestMonths: [1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'epinard',
    sowingMonths: [10, 11, 12, 1],
    harvestMonths: [12, 1, 2, 3],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'oignon',
    sowingMonths: [9, 10, 11],
    harvestMonths: [1, 2, 3, 4],
  ),
  RegionData(
    regionId: 'west_africa',
    vegetableId: 'basilic',
    sowingMonths: [6, 7, 8, 9, 10],
    harvestMonths: [8, 9, 10, 11, 12],
  ),
];
