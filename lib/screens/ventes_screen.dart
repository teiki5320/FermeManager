import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/vente.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';
import '../widgets/form_sheet.dart';
import '../widgets/info_card.dart';
import '../widgets/screen_header.dart';
import '../widgets/stat_card.dart';

class VentesScreen extends StatelessWidget {
  const VentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ventes = state.ventes;
    final totalCa = state.totalVentesFcfa;
    final now = DateTime.now();
    final moisCa = ventes
        .where((v) => v.date.month == now.month && v.date.year == now.year)
        .fold<double>(0, (s, v) => s + v.total);

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AddFab(
        onPressed: () => _openForm(context),
        tooltip: 'Nouvelle vente',
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Ventes',
              subtitle: 'Transactions et chiffre d\'affaires',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopping_cart,
                      iconColor: AppTheme.accent,
                      iconBg: AppTheme.accentSoft,
                      value: '${ventes.length}',
                      label: 'Ventes',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: StatCard(
                      icon: Icons.account_balance_wallet,
                      iconColor: AppTheme.success,
                      iconBg: AppTheme.successSoft,
                      value: Fmt.fcfa(totalCa),
                      label: 'CA total',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InfoCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        color: AppTheme.accent, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Ce mois-ci',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Fmt.fcfa(moisCa),
                      style: const TextStyle(
                        color: AppTheme.accentDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ventes.isEmpty
                  ? const EmptyState(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Aucune vente enregistrée',
                      message:
                          'Enregistrez vos ventes pour suivre votre chiffre d\'affaires.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: ventes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _VenteTile(item: ventes[i]),
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
      title: 'Nouvelle vente',
      child: _VenteForm(
        onSubmit: (produit, client, date, qte, unite, prix) async {
          await context.read<AppState>().addVente(
                produit: produit,
                client: client,
                date: date,
                quantite: qte,
                unite: unite,
                prixUnitaire: prix,
              );
        },
      ),
    );
  }
}

class _VenteTile extends StatelessWidget {
  final Vente item;

  const _VenteTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_cart,
                color: AppTheme.success, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produit,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.client} • ${Fmt.date(item.date)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Fmt.number(item.quantite, decimals: 1)} ${item.unite} × ${Fmt.fcfa(item.prixUnitaire)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Fmt.fcfa(item.total),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.success,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline,
                    color: AppTheme.error, size: 18),
                onPressed: () =>
                    context.read<AppState>().removeVente(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VenteForm extends StatefulWidget {
  final Future<void> Function(String produit, String client, DateTime date,
      double qte, String unite, double prix) onSubmit;

  const _VenteForm({required this.onSubmit});

  @override
  State<_VenteForm> createState() => _VenteFormState();
}

class _VenteFormState extends State<_VenteForm> {
  final _formKey = GlobalKey<FormState>();
  final _produitCtrl = TextEditingController();
  final _clientCtrl = TextEditingController();
  final _qteCtrl = TextEditingController();
  final _prixCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _unite = 'kg';

  @override
  void dispose() {
    _produitCtrl.dispose();
    _clientCtrl.dispose();
    _qteCtrl.dispose();
    _prixCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final qte = double.tryParse(_qteCtrl.text.replaceAll(',', '.'));
    final prix = double.tryParse(_prixCtrl.text.replaceAll(',', '.'));
    if (qte == null || prix == null || qte <= 0 || prix < 0) return;
    await widget.onSubmit(
      _produitCtrl.text.trim(),
      _clientCtrl.text.trim(),
      _date,
      qte,
      _unite,
      prix,
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
            controller: _produitCtrl,
            label: 'Produit',
            hint: 'Ex : Tomates',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormTextField(
            controller: _clientCtrl,
            label: 'Client',
            hint: 'Ex : Marché central',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormDateField(
            label: 'Date',
            value: _date,
            onChanged: (d) => setState(() => _date = d),
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
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requis' : null,
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
            controller: _prixCtrl,
            label: 'Prix unitaire (FCFA)',
            hint: 'Ex : 500',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          FormSubmitButton(
              label: 'Enregistrer la vente', onPressed: _submit),
        ],
      ),
    );
  }
}
