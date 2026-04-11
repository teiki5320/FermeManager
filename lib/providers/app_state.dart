import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/compta_transaction.dart';
import '../models/culture.dart';
import '../models/intrant.dart';
import '../models/irrigation.dart';
import '../models/recolte.dart';
import '../models/vente.dart';

/// État global de l'application.
/// Contient toutes les données des 6 modules, persistées en JSON
/// dans SharedPreferences.
class AppState extends ChangeNotifier {
  // Clés de stockage
  static const _kCultures = 'ferme_cultures';
  static const _kIrrigations = 'ferme_irrigations';
  static const _kIntrants = 'ferme_intrants';
  static const _kRecoltes = 'ferme_recoltes';
  static const _kVentes = 'ferme_ventes';
  static const _kCompta = 'ferme_compta';

  List<Culture> _cultures = [];
  List<Irrigation> _irrigations = [];
  List<Intrant> _intrants = [];
  List<Recolte> _recoltes = [];
  List<Vente> _ventes = [];
  List<ComptaTransaction> _compta = [];

  bool _loading = true;
  bool get loading => _loading;

  // ── Accesseurs triés ────────────────────────────────

  List<Culture> get cultures =>
      List.unmodifiable(_cultures..sort((a, b) => b.dateSemis.compareTo(a.dateSemis)));

  List<Irrigation> get irrigations => List.unmodifiable(
      _irrigations..sort((a, b) => b.date.compareTo(a.date)));

  List<Intrant> get intrants =>
      List.unmodifiable(_intrants..sort((a, b) => a.nom.compareTo(b.nom)));

  List<Recolte> get recoltes =>
      List.unmodifiable(_recoltes..sort((a, b) => b.date.compareTo(a.date)));

  List<Vente> get ventes =>
      List.unmodifiable(_ventes..sort((a, b) => b.date.compareTo(a.date)));

  List<ComptaTransaction> get compta =>
      List.unmodifiable(_compta..sort((a, b) => b.date.compareTo(a.date)));

  // ── Stats utilitaires ────────────────────────────────

  double get totalVentesFcfa => _ventes.fold(0.0, (sum, v) => sum + v.total);

  double get totalRevenuFcfa =>
      _compta.where((t) => t.type == ComptaType.revenu).fold(
            0.0,
            (sum, t) => sum + t.montant,
          );

  double get totalDepenseFcfa =>
      _compta.where((t) => t.type == ComptaType.depense).fold(
            0.0,
            (sum, t) => sum + t.montant,
          );

  double get bilanFcfa => totalRevenuFcfa - totalDepenseFcfa;

  int get intrantsEnAlerte => _intrants.where((i) => i.enAlerte).length;

  double get totalRecoltesKg =>
      _recoltes.fold(0.0, (sum, r) => sum + r.quantiteKg);

  // ── Chargement ───────────────────────────────────────

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _cultures = _loadList(prefs, _kCultures, Culture.fromJson);
      _irrigations = _loadList(prefs, _kIrrigations, Irrigation.fromJson);
      _intrants = _loadList(prefs, _kIntrants, Intrant.fromJson);
      _recoltes = _loadList(prefs, _kRecoltes, Recolte.fromJson);
      _ventes = _loadList(prefs, _kVentes, Vente.fromJson);
      _compta = _loadList(prefs, _kCompta, ComptaTransaction.fromJson);
    } catch (e) {
      debugPrint('Erreur chargement AppState: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<T> _loadList<T>(
    SharedPreferences prefs,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = prefs.getString(key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveList<T>(
    String key,
    List<T> list,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(list.map(toJson).toList());
    await prefs.setString(key, raw);
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  // ── Cultures ─────────────────────────────────────────

  Future<void> addCulture({
    required String parcelle,
    required String nom,
    required DateTime dateSemis,
    required String stade,
    required int progression,
    required DateTime dateRecoltePrevue,
    required String etatSanitaire,
  }) async {
    _cultures.add(Culture(
      id: _newId(),
      parcelle: parcelle,
      nom: nom,
      dateSemis: dateSemis,
      stade: stade,
      progression: progression,
      dateRecoltePrevue: dateRecoltePrevue,
      etatSanitaire: etatSanitaire,
    ));
    await _saveList(_kCultures, _cultures, (c) => c.toJson());
    notifyListeners();
  }

  Future<void> removeCulture(String id) async {
    _cultures.removeWhere((c) => c.id == id);
    await _saveList(_kCultures, _cultures, (c) => c.toJson());
    notifyListeners();
  }

  // ── Irrigations ──────────────────────────────────────

  Future<void> addIrrigation({
    required String parcelle,
    required DateTime date,
    required double volumeM3,
    required String source,
    String note = '',
  }) async {
    _irrigations.add(Irrigation(
      id: _newId(),
      parcelle: parcelle,
      date: date,
      volumeM3: volumeM3,
      source: source,
      note: note,
    ));
    await _saveList(_kIrrigations, _irrigations, (i) => i.toJson());
    notifyListeners();
  }

  Future<void> removeIrrigation(String id) async {
    _irrigations.removeWhere((i) => i.id == id);
    await _saveList(_kIrrigations, _irrigations, (i) => i.toJson());
    notifyListeners();
  }

  // ── Intrants ─────────────────────────────────────────

  Future<void> addIntrant({
    required String nom,
    required String type,
    required double quantite,
    required String unite,
    required double stockMinimum,
    DateTime? datePeremption,
  }) async {
    _intrants.add(Intrant(
      id: _newId(),
      nom: nom,
      type: type,
      quantite: quantite,
      unite: unite,
      stockMinimum: stockMinimum,
      datePeremption: datePeremption,
    ));
    await _saveList(_kIntrants, _intrants, (i) => i.toJson());
    notifyListeners();
  }

  Future<void> removeIntrant(String id) async {
    _intrants.removeWhere((i) => i.id == id);
    await _saveList(_kIntrants, _intrants, (i) => i.toJson());
    notifyListeners();
  }

  // ── Récoltes ─────────────────────────────────────────

  Future<void> addRecolte({
    required String culture,
    required String parcelle,
    required DateTime date,
    required double quantiteKg,
    required String qualite,
    String note = '',
  }) async {
    _recoltes.add(Recolte(
      id: _newId(),
      culture: culture,
      parcelle: parcelle,
      date: date,
      quantiteKg: quantiteKg,
      qualite: qualite,
      note: note,
    ));
    await _saveList(_kRecoltes, _recoltes, (r) => r.toJson());
    notifyListeners();
  }

  Future<void> removeRecolte(String id) async {
    _recoltes.removeWhere((r) => r.id == id);
    await _saveList(_kRecoltes, _recoltes, (r) => r.toJson());
    notifyListeners();
  }

  // ── Ventes ───────────────────────────────────────────

  Future<void> addVente({
    required String produit,
    required String client,
    required DateTime date,
    required double quantite,
    required String unite,
    required double prixUnitaire,
  }) async {
    _ventes.add(Vente(
      id: _newId(),
      produit: produit,
      client: client,
      date: date,
      quantite: quantite,
      unite: unite,
      prixUnitaire: prixUnitaire,
    ));
    await _saveList(_kVentes, _ventes, (v) => v.toJson());
    notifyListeners();
  }

  Future<void> removeVente(String id) async {
    _ventes.removeWhere((v) => v.id == id);
    await _saveList(_kVentes, _ventes, (v) => v.toJson());
    notifyListeners();
  }

  // ── Comptabilité ─────────────────────────────────────

  Future<void> addCompta({
    required ComptaType type,
    required String categorie,
    required double montant,
    required DateTime date,
    String description = '',
  }) async {
    _compta.add(ComptaTransaction(
      id: _newId(),
      type: type,
      categorie: categorie,
      montant: montant,
      date: date,
      description: description,
    ));
    await _saveList(_kCompta, _compta, (t) => t.toJson());
    notifyListeners();
  }

  Future<void> removeCompta(String id) async {
    _compta.removeWhere((t) => t.id == id);
    await _saveList(_kCompta, _compta, (t) => t.toJson());
    notifyListeners();
  }
}
