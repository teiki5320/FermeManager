import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/culture.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

/// Écran Cultures — liste des cultures avec CRUD.
class CulturesScreen extends StatelessWidget {
  const CulturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cultures = state.cultures;
    final bonCount = cultures.where((c) => c.etatSanitaire == 'Bon').length;
    final attentionCount =
        cultures.where((c) => c.etatSanitaire == 'Attention').length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvelle culture',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Cultures',
              subtitle: 'Suivi des semis et de la croissance',
            ),

            // Résumé
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.eco,
                      iconColor: AppTheme.accent,
                      iconBg: AppTheme.accentSoft,
                      value: '${cultures.length}',
                      label: 'Cultures',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle,
                      iconColor: AppTheme.success,
                      iconBg: AppTheme.successSoft,
                      value: '$bonCount',
                      label: 'En bonne santé',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppTheme.warning,
                      iconBg: AppTheme.warningSoft,
                      value: '$attentionCount',
                      label: 'Attention',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Liste
            Expanded(
              child: cultures.isEmpty
                  ? const EmptyState(
                      icon: Icons.eco_outlined,
                      title: 'Aucune culture enregistrée',
                      message:
                          'Appuyez sur « Nouvelle culture » pour en ajouter une.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: cultures.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _CultureCard(culture: cultures[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openForm(BuildContext context) {
    FormSheet.show<void>(
      context,
      title: 'Nouvelle culture',
      child: _CultureForm(
        onSubmit: (data) async {
          await context.read<AppState>().addCulture(
                parcelle: data.parcelle,
                nom: data.nom,
                dateSemis: data.dateSemis,
                stade: data.stade,
                progression: data.progression,
                dateRecoltePrevue: data.dateRecoltePrevue,
                etatSanitaire: data.etatSanitaire,
              );
        },
      ),
    );
  }
}

class _CultureCard extends StatelessWidget {
  final Culture culture;

  const _CultureCard({required this.culture});

  Color get _etatColor {
    switch (culture.etatSanitaire) {
      case 'Bon':
        return AppTheme.success;
      case 'Attention':
        return AppTheme.warning;
      case 'Critique':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  Color get _etatBg {
    switch (culture.etatSanitaire) {
      case 'Bon':
        return AppTheme.successSoft;
      case 'Attention':
        return AppTheme.warningSoft;
      case 'Critique':
        return AppTheme.errorSoft;
      default:
        return AppTheme.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco,
                          color: AppTheme.accentDark, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            culture.nom,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            culture.parcelle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ColoredPill(
                label: culture.etatSanitaire,
                color: _etatColor,
                bgColor: _etatBg,
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.more_vert,
                    size: 18, color: AppTheme.textSecondary),
                onPressed: () => _showDeleteMenu(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: culture.progression / 100,
                    minHeight: 8,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.accent),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 42,
                child: Text(
                  '${culture.progression}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.accentDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _detailRow(Icons.calendar_today_outlined, 'Semis',
              Fmt.date(culture.dateSemis)),
          const SizedBox(height: 6),
          _detailRow(Icons.spa_outlined, 'Stade', culture.stade),
          const SizedBox(height: 6),
          _detailRow(Icons.event_available_outlined, 'Récolte prévue',
              Fmt.date(culture.dateRecoltePrevue)),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.delete_outline,
                  color: AppTheme.error),
              title: const Text('Supprimer cette culture',
                  style: TextStyle(
                    color: AppTheme.error,
                    fontWeight: FontWeight.w700,
                  )),
              onTap: () {
                Navigator.of(ctx).pop();
                context.read<AppState>().removeCulture(culture.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────── Formulaire ────────────────────────────

class _CultureFormData {
  final String parcelle;
  final String nom;
  final DateTime dateSemis;
  final String stade;
  final int progression;
  final DateTime dateRecoltePrevue;
  final String etatSanitaire;

  _CultureFormData({
    required this.parcelle,
    required this.nom,
    required this.dateSemis,
    required this.stade,
    required this.progression,
    required this.dateRecoltePrevue,
    required this.etatSanitaire,
  });
}

class _CultureForm extends StatefulWidget {
  final Future<void> Function(_CultureFormData) onSubmit;

  const _CultureForm({required this.onSubmit});

  @override
  State<_CultureForm> createState() => _CultureFormState();
}

class _CultureFormState extends State<_CultureForm> {
  final _formKey = GlobalKey<FormState>();
  final _parcelleCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _stadeCtrl = TextEditingController();
  final _progressionCtrl = TextEditingController(text: '50');
  DateTime _dateSemis = DateTime.now();
  DateTime _dateRecolte = DateTime.now().add(const Duration(days: 90));
  String _etat = 'Bon';

  @override
  void dispose() {
    _parcelleCtrl.dispose();
    _nomCtrl.dispose();
    _stadeCtrl.dispose();
    _progressionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final data = _CultureFormData(
      parcelle: _parcelleCtrl.text.trim(),
      nom: _nomCtrl.text.trim(),
      dateSemis: _dateSemis,
      stade: _stadeCtrl.text.trim(),
      progression: int.tryParse(_progressionCtrl.text)?.clamp(0, 100) ?? 50,
      dateRecoltePrevue: _dateRecolte,
      etatSanitaire: _etat,
    );
    await widget.onSubmit(data);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormTextField(
            controller: _nomCtrl,
            label: 'Nom de la culture',
            hint: 'Ex : Tomates',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormTextField(
            controller: _parcelleCtrl,
            label: 'Parcelle',
            hint: 'Ex : Parcelle A',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormDateField(
            label: 'Date de semis',
            value: _dateSemis,
            onChanged: (d) => setState(() => _dateSemis = d),
          ),
          FormDateField(
            label: 'Récolte prévue',
            value: _dateRecolte,
            onChanged: (d) => setState(() => _dateRecolte = d),
          ),
          FormTextField(
            controller: _stadeCtrl,
            label: 'Stade actuel',
            hint: 'Ex : Floraison',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormTextField(
            controller: _progressionCtrl,
            label: 'Progression (%)',
            hint: '0 à 100',
            keyboardType: TextInputType.number,
          ),
          FormDropdown<String>(
            label: 'État sanitaire',
            value: _etat,
            items: const [
              DropdownMenuItem(value: 'Bon', child: Text('Bon')),
              DropdownMenuItem(value: 'Attention', child: Text('Attention')),
              DropdownMenuItem(value: 'Critique', child: Text('Critique')),
            ],
            onChanged: (v) => setState(() => _etat = v ?? 'Bon'),
          ),
          FormSubmitButton(label: 'Ajouter la culture', onPressed: _submit),
        ],
      ),
    );
  }
}
