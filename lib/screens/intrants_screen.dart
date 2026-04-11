import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/intrant.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

class IntrantsScreen extends StatelessWidget {
  const IntrantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final intrants = state.intrants;
    final enAlerte = intrants.where((i) => i.enAlerte).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvel intrant',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Intrants',
              subtitle: 'Stocks d\'engrais, semences, produits',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.inventory_2,
                      iconColor: AppTheme.accent,
                      iconBg: AppTheme.accentSoft,
                      value: '${intrants.length}',
                      label: 'Références',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppTheme.warning,
                      iconBg: AppTheme.warningSoft,
                      value: '$enAlerte',
                      label: 'En alerte',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: intrants.isEmpty
                  ? const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Aucun intrant enregistré',
                      message:
                          'Ajoutez vos engrais, semences, pesticides, etc.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: intrants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _IntrantTile(item: intrants[i]),
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
      title: 'Nouvel intrant',
      child: _IntrantForm(
        onSubmit: (nom, type, qte, unite, stockMin) async {
          await context.read<AppState>().addIntrant(
                nom: nom,
                type: type,
                quantite: qte,
                unite: unite,
                stockMinimum: stockMin,
              );
        },
      ),
    );
  }
}

class _IntrantTile extends StatelessWidget {
  final Intrant item;

  const _IntrantTile({required this.item});

  IconData get _typeIcon {
    switch (item.type) {
      case 'Engrais':
        return Icons.grass;
      case 'Semence':
        return Icons.spa;
      case 'Pesticide':
        return Icons.pest_control;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alerte = item.enAlerte;

    return InfoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: alerte ? AppTheme.warningSoft : AppTheme.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _typeIcon,
              color: alerte ? AppTheme.warning : AppTheme.accentDark,
              size: 22,
            ),
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
                        item.nom,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.text,
                        ),
                      ),
                    ),
                    ColoredPill(
                      label: item.type,
                      color: AppTheme.accentDark,
                      bgColor: AppTheme.accentSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${Fmt.number(item.quantite, decimals: 1)} ${item.unite}',
                      style: TextStyle(
                        fontSize: 13,
                        color: alerte ? AppTheme.warning : AppTheme.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(min ${Fmt.number(item.stockMinimum, decimals: 1)})',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (alerte) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.warning_amber_rounded,
                          size: 14, color: AppTheme.warning),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppTheme.error, size: 20),
            onPressed: () =>
                context.read<AppState>().removeIntrant(item.id),
          ),
        ],
      ),
    );
  }
}

class _IntrantForm extends StatefulWidget {
  final Future<void> Function(
    String nom,
    String type,
    double quantite,
    String unite,
    double stockMin,
  ) onSubmit;

  const _IntrantForm({required this.onSubmit});

  @override
  State<_IntrantForm> createState() => _IntrantFormState();
}

class _IntrantFormState extends State<_IntrantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _qteCtrl = TextEditingController();
  final _minCtrl = TextEditingController(text: '0');
  String _type = 'Engrais';
  String _unite = 'kg';

  @override
  void dispose() {
    _nomCtrl.dispose();
    _qteCtrl.dispose();
    _minCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final qte = double.tryParse(_qteCtrl.text.replaceAll(',', '.')) ?? 0;
    final min = double.tryParse(_minCtrl.text.replaceAll(',', '.')) ?? 0;
    await widget.onSubmit(
      _nomCtrl.text.trim(),
      _type,
      qte,
      _unite,
      min,
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
            controller: _nomCtrl,
            label: "Nom de l'intrant",
            hint: 'Ex : NPK 15-15-15',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormDropdown<String>(
            label: 'Type',
            value: _type,
            items: const [
              DropdownMenuItem(value: 'Engrais', child: Text('Engrais')),
              DropdownMenuItem(value: 'Semence', child: Text('Semence')),
              DropdownMenuItem(value: 'Pesticide', child: Text('Pesticide')),
              DropdownMenuItem(value: 'Autre', child: Text('Autre')),
            ],
            onChanged: (v) => setState(() => _type = v ?? 'Engrais'),
          ),
          Row(
            children: [
              Expanded(
                child: FormTextField(
                  controller: _qteCtrl,
                  label: 'Quantité',
                  hint: 'Ex : 50',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requis';
                    final n = double.tryParse(v.replaceAll(',', '.'));
                    if (n == null || n < 0) return 'Invalide';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 110,
                child: FormDropdown<String>(
                  label: 'Unité',
                  value: _unite,
                  items: const [
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'L', child: Text('L')),
                    DropdownMenuItem(value: 'unité', child: Text('unité')),
                  ],
                  onChanged: (v) => setState(() => _unite = v ?? 'kg'),
                ),
              ),
            ],
          ),
          FormTextField(
            controller: _minCtrl,
            label: 'Stock minimum (alerte)',
            hint: '0 pour désactiver',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          FormSubmitButton(label: "Ajouter l'intrant", onPressed: _submit),
        ],
      ),
    );
  }
}
