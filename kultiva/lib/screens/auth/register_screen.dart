import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onSignedIn;
  const RegisterScreen({super.key, required this.onSignedIn});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.instance.registerWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        name: _nameCtrl.text.trim(),
      );
      if (mounted) widget.onSignedIn();
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: <Widget>[
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: KultivaColors.lightGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: const Text('🌿', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Rejoins Kultiva',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Prénom requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email requis';
                      }
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) {
                        return '6 caractères minimum';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            if (_error != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Créer mon compte"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
