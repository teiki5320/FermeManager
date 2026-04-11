import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/recolte.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

class RecoltesScreen extends StatelessWidget {
  const RecoltesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final recoltes = state.recoltes;
    final totalKg = state.totalRecoltesKg;
    final qualiteA = recoltes.where((r) => r.qualite == 'A').length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvelle récolte',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Récoltes',
              subtitle: 'Suivi des récoltes par parcelle',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopping_basket,
                      iconColor: AppTheme.accent,
                      iconBg: AppTheme.accentSoft,
                      value: '${recoltes.length}',
                      label: 'Récoltes',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.scale,
                      iconColor: AppTheme.secondary,
                      iconBg: AppTheme.secondarySoft,
                      value: '${Fmt.number(totalKg, decimals: 0)} kg',
                      label: 'Total récolté',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.star,
                      iconColor: AppTheme.success,
                      iconBg: AppTheme.successSoft,
                      value: '$qualiteA',
                      label: 'Qualité A',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recoltes.isEmpty
                  ? const EmptyState(
                      icon: Icons.shopping_basket_outlined,
                      title: 'Aucune récolte enregistrée',
                      message:
                          'Enregistrez vos récoltes pour suivre vos rendements.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: recoltes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _RecolteTile(item: recoltes[i]),
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
      title: 'Nouvelle récolte',
      child: _RecolteForm(
        onSubmit: (culture, parcelle, date, qte, qualite, note) async {
          await context.read<AppState>().addRecolte(
                culture: culture,
                parcelle: parcelle,
                date: date,
                quantiteKg: qte,
                qualite: qualite,
                note: note,
              );
        },
      ),
    );
  }
}

class _RecolteTile extends StatelessWidget {
  final Recolte item;

  const _RecolteTile({required this.item});

  Color get _qualiteColor {
    switch (item.qualite) {
      case 'A':
        return AppTheme.success;
      case 'B':
        return AppTheme.warning;
      default:
        return AppTheme.error;
    }
  }

  Color get _qualiteBg {
    switch (item.qualite) {
      case 'A':
        return AppTheme.successSoft;
      case 'B':
        return AppTheme.warningSoft;
      default:
        return AppTheme.errorSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_basket,
                color: AppTheme.accentDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.culture,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.text,
                        ),
                      ),
                    ),
                    ColoredPill(
                      label: 'Qualité ${item.qualite}',
                      color: _qualiteColor,
                      bgColor: _qualiteBg,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.parcelle} • ${Fmt.number(item.quantiteKg, decimals: 0)} kg • ${Fmt.date(item.date)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppTheme.error, size: 20),
            onPressed: () =>
                context.read<AppState>().removeRecolte(item.id),
          ),
        ],
      ),
    );
  }
}

class _RecolteForm extends StatefulWidget {
  final Future<void> Function(String culture, String parcelle, DateTime date,
      double qte, String qualite, String note) onSubmit;

  const _RecolteForm({required this.onSubmit});

  @override
  State<_RecolteForm> createState() => _RecolteFormState();
}

class _RecolteFormState extends State<_RecolteForm> {
  final _formKey = GlobalKey<FormState>();
  final _cultureCtrl = TextEditingController();
  final _parcelleCtrl = TextEditingController();
  final _qteCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _qualite = 'A';

  @override
  void dispose() {
    _cultureCtrl.dispose();
    _parcelleCtrl.dispose();
    _qteCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final qte = double.tryParse(_qteCtrl.text.replaceAll(',', '.'));
    if (qte == null || qte <= 0) return;
    await widget.onSubmit(
      _cultureCtrl.text.trim(),
      _parcelleCtrl.text.trim(),
      _date,
      qte,
      _qualite,
      _noteCtrl.text.trim(),
    );
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
            controller: _cultureCtrl,
            label: 'Culture',
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
            label: 'Date de récolte',
            value: _date,
            onChanged: (d) => setState(() => _date = d),
          ),
          FormTextField(
            controller: _qteCtrl,
            label: 'Quantité (kg)',
            hint: 'Ex : 120',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Requis';
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null || n <= 0) return 'Invalide';
              return null;
            },
          ),
          FormDropdown<String>(
            label: 'Qualité',
            value: _qualite,
            items: const [
              DropdownMenuItem(value: 'A', child: Text('A (supérieure)')),
              DropdownMenuItem(value: 'B', child: Text('B (standard)')),
              DropdownMenuItem(value: 'C', child: Text('C (faible)')),
            ],
            onChanged: (v) => setState(() => _qualite = v ?? 'A'),
          ),
          FormTextField(
            controller: _noteCtrl,
            label: 'Note (optionnel)',
            maxLines: 2,
          ),
          FormSubmitButton(
              label: 'Ajouter la récolte', onPressed: _submit),
        ],
      ),
    );
  }
}
