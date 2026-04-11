import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/theme.dart';
import '../providers/modules_provider.dart';

/// Wrap un écran en mode démo : bandeau pastel + contenu atténué + zone de déblocage.
class ModuleVerrouille extends StatefulWidget {
  final String moduleName;
  final String prix;
  final Widget child;

  const ModuleVerrouille({
    super.key,
    required this.moduleName,
    required this.prix,
    required this.child,
  });

  @override
  State<ModuleVerrouille> createState() => _ModuleVerrouilleState();
}

class _ModuleVerrouilleState extends State<ModuleVerrouille> {
  final TextEditingController _codeCtrl = TextEditingController();
  bool _showUnlock = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleWhatsApp() async {
    final msg = Uri.encodeComponent(
      'Bonjour, je veux débloquer le module ${widget.moduleName} '
      'de FermeManager (${widget.prix}).',
    );
    // TODO: remplacer par le vrai numéro WhatsApp.
    final uri = Uri.parse('https://wa.me/33XXXXXXXXX?text=$msg');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      _showAlert('Erreur', "Impossible d'ouvrir WhatsApp.");
    }
  }

  Future<void> _handleUnlock() async {
    if (_codeCtrl.text.length != 8) {
      _showAlert('Erreur', 'Le code doit contenir 8 chiffres.');
      return;
    }
    final provider = context.read<ModulesProvider>();
    final result = await provider.tryUnlock(_codeCtrl.text);
    if (!mounted) return;
    _showAlert(result.success ? 'Succès' : 'Erreur', result.message);
    if (result.success) {
      _codeCtrl.clear();
      setState(() => _showUnlock = false);
    }
  }

  void _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title, style: const TextStyle(color: AppTheme.text)),
        content: Text(message, style: const TextStyle(color: AppTheme.text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppTheme.accent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bandeau pastel "Mode démo"
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: const BoxDecoration(
            color: AppTheme.secondarySoft,
            border: Border(
              bottom: BorderSide(color: AppTheme.border),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Mode démo — Débloquer pour ${widget.prix}',
                style: const TextStyle(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Contenu démo semi-transparent, non-interactif
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: IgnorePointer(child: widget.child),
          ),
        ),
        // Zone d'action
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          child: SafeArea(
            top: false,
            child: _showUnlock ? _buildCodeInput() : _buildButtons(),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleWhatsApp,
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Commander via WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF75C796),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _showUnlock = true),
            icon: const Icon(Icons.vpn_key_outlined, color: AppTheme.accent),
            label: const Text(
              "J'ai un code",
              style: TextStyle(color: AppTheme.accent),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppTheme.accentSoft,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Entrez votre code de déblocage',
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• • • • • • • •',
                  hintStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                    letterSpacing: 4,
                  ),
                  filled: true,
                  fillColor: AppTheme.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.accent),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _handleUnlock,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                elevation: 0,
              ),
              child: const Text('Valider'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => setState(() => _showUnlock = false),
          child: const Text(
            'Annuler',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
