import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/compta_transaction.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';

class ComptabiliteScreen extends StatelessWidget {
  const ComptabiliteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final transactions = state.compta;
    final bilan = state.bilanFcfa;
    final bilanColor =
        bilan >= 0 ? AppTheme.success : AppTheme.error;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvelle transaction',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Comptabilité',
              subtitle: 'Revenus, dépenses et bilan',
            ),

            // Bilan en grand
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bilan',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Fmt.fcfa(bilan),
                      style: TextStyle(
                        color: bilanColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            label: 'Revenus',
                            value: Fmt.fcfa(state.totalRevenuFcfa),
                            icon: Icons.trending_up,
                            color: AppTheme.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniStat(
                            label: 'Dépenses',
                            value: Fmt.fcfa(state.totalDepenseFcfa),
                            icon: Icons.trending_down,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Liste
            Expanded(
              child: transactions.isEmpty
                  ? const EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'Aucune transaction',
                      message:
                          'Enregistrez vos revenus et dépenses pour suivre votre bilan.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _TransactionTile(item: transactions[i]),
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
      title: 'Nouvelle transaction',
      child: _ComptaForm(
        onSubmit: (type, categorie, montant, date, description) async {
          await context.read<AppState>().addCompta(
                type: type,
                categorie: categorie,
                montant: montant,
                date: date,
                description: description,
              );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final ComptaTransaction item;

  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isRevenu = item.type == ComptaType.revenu;
    final color = isRevenu ? AppTheme.success : AppTheme.error;
    final bg = isRevenu ? AppTheme.successSoft : AppTheme.errorSoft;

    return InfoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isRevenu ? Icons.add_circle_outline : Icons.remove_circle_outline,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.categorie,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Fmt.date(item.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isRevenu ? "+" : "−"} ${Fmt.fcfa(item.montant)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline,
                    color: AppTheme.error, size: 18),
                onPressed: () =>
                    context.read<AppState>().removeCompta(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComptaForm extends StatefulWidget {
  final Future<void> Function(ComptaType type, String categorie,
      double montant, DateTime date, String description) onSubmit;

  const _ComptaForm({required this.onSubmit});

  @override
  State<_ComptaForm> createState() => _ComptaFormState();
}

class _ComptaFormState extends State<_ComptaForm> {
  final _formKey = GlobalKey<FormState>();
  final _categorieCtrl = TextEditingController();
  final _montantCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  ComptaType _type = ComptaType.revenu;

  @override
  void dispose() {
    _categorieCtrl.dispose();
    _montantCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final montant = double.tryParse(_montantCtrl.text.replaceAll(',', '.'));
    if (montant == null || montant <= 0) return;
    await widget.onSubmit(
      _type,
      _categorieCtrl.text.trim(),
      montant,
      _date,
      _descCtrl.text.trim(),
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
          // Sélecteur type (segmented)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  _typeButton(ComptaType.revenu, 'Revenu', AppTheme.success),
                  _typeButton(ComptaType.depense, 'Dépense', AppTheme.error),
                ],
              ),
            ),
          ),
          FormTextField(
            controller: _categorieCtrl,
            label: 'Catégorie',
            hint: _type == ComptaType.revenu
                ? 'Ex : Vente tomates'
                : 'Ex : Achat engrais',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormTextField(
            controller: _montantCtrl,
            label: 'Montant (FCFA)',
            hint: 'Ex : 25000',
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Requis';
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null || n <= 0) return 'Invalide';
              return null;
            },
          ),
          FormDateField(
            label: 'Date',
            value: _date,
            onChanged: (d) => setState(() => _date = d),
          ),
          FormTextField(
            controller: _descCtrl,
            label: 'Description (optionnel)',
            maxLines: 2,
          ),
          FormSubmitButton(label: 'Enregistrer', onPressed: _submit),
        ],
      ),
    );
  }

  Widget _typeButton(ComptaType type, String label, Color color) {
    final selected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
