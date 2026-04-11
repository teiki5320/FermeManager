import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/irrigation.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

class IrrigationScreen extends StatelessWidget {
  const IrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final irrigations = state.irrigations;
    final totalM3 = irrigations.fold<double>(0, (s, i) => s + i.volumeM3);
    final thisMonth = irrigations
        .where((i) => i.date.month == DateTime.now().month &&
            i.date.year == DateTime.now().year)
        .length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvel arrosage',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Irrigation',
              subtitle: 'Suivi des arrosages par parcelle',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.water_drop,
                      iconColor: AppTheme.accent,
                      iconBg: AppTheme.accentSoft,
                      value: '${irrigations.length}',
                      label: 'Arrosages',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.opacity,
                      iconColor: AppTheme.secondary,
                      iconBg: AppTheme.secondarySoft,
                      value: '${Fmt.number(totalM3, decimals: 1)} m³',
                      label: 'Volume total',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.calendar_month,
                      iconColor: AppTheme.success,
                      iconBg: AppTheme.successSoft,
                      value: '$thisMonth',
                      label: 'Ce mois-ci',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: irrigations.isEmpty
                  ? const EmptyState(
                      icon: Icons.water_drop_outlined,
                      title: 'Aucun arrosage enregistré',
                      message:
                          'Ajoutez votre premier arrosage avec le bouton « + ».',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: irrigations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _IrrigationTile(item: irrigations[i]),
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
      title: 'Nouvel arrosage',
      child: _IrrigationForm(
        onSubmit: (parcelle, date, volume, source, note) async {
          await context.read<AppState>().addIrrigation(
                parcelle: parcelle,
                date: date,
                volumeM3: volume,
                source: source,
                note: note,
              );
        },
      ),
    );
  }
}

class _IrrigationTile extends StatelessWidget {
  final Irrigation item;

  const _IrrigationTile({required this.item});

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
            child: const Icon(Icons.water_drop,
                color: AppTheme.accentDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.parcelle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ColoredPill(
                      label: item.source,
                      color: AppTheme.secondary,
                      bgColor: AppTheme.secondarySoft,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${Fmt.number(item.volumeM3, decimals: 1)} m³ • ${Fmt.date(item.date)}',
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
                context.read<AppState>().removeIrrigation(item.id),
          ),
        ],
      ),
    );
  }
}

class _IrrigationForm extends StatefulWidget {
  final Future<void> Function(String parcelle, DateTime date, double volume,
      String source, String note) onSubmit;

  const _IrrigationForm({required this.onSubmit});

  @override
  State<_IrrigationForm> createState() => _IrrigationFormState();
}

class _IrrigationFormState extends State<_IrrigationForm> {
  final _formKey = GlobalKey<FormState>();
  final _parcelleCtrl = TextEditingController();
  final _volumeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _source = 'Puits';

  @override
  void dispose() {
    _parcelleCtrl.dispose();
    _volumeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final volume = double.tryParse(_volumeCtrl.text.replaceAll(',', '.'));
    if (volume == null || volume <= 0) return;
    await widget.onSubmit(
      _parcelleCtrl.text.trim(),
      _date,
      volume,
      _source,
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
            controller: _parcelleCtrl,
            label: 'Parcelle',
            hint: 'Ex : Parcelle A',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormDateField(
            label: 'Date',
            value: _date,
            onChanged: (d) => setState(() => _date = d),
          ),
          FormTextField(
            controller: _volumeCtrl,
            label: 'Volume (m³)',
            hint: 'Ex : 2.5',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Requis';
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null || n <= 0) return 'Valeur invalide';
              return null;
            },
          ),
          FormDropdown<String>(
            label: 'Source',
            value: _source,
            items: const [
              DropdownMenuItem(value: 'Puits', child: Text('Puits')),
              DropdownMenuItem(value: 'Forage', child: Text('Forage')),
              DropdownMenuItem(value: 'Pluviale', child: Text('Pluviale')),
              DropdownMenuItem(value: 'Réseau', child: Text('Réseau')),
            ],
            onChanged: (v) => setState(() => _source = v ?? 'Puits'),
          ),
          FormTextField(
            controller: _noteCtrl,
            label: 'Note (optionnel)',
            hint: 'Ex : arrosage du matin',
            maxLines: 2,
          ),
          FormSubmitButton(label: "Ajouter l'arrosage", onPressed: _submit),
        ],
      ),
    );
  }
}
