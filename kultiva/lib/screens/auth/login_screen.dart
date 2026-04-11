import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignedIn;
  const LoginScreen({super.key, required this.onSignedIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
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
      await AuthService.instance.signInWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (mounted) widget.onSignedIn();
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _socialSignIn(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) widget.onSignedIn();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: <Widget>[
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: KultivaColors.lightGreen.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: const Text('🌱', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bon retour !',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Connecte-toi pour retrouver ton jardin',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KultivaColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
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
                    : const Text('Se connecter'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loading
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => RegisterScreen(
                            onSignedIn: widget.onSignedIn,
                          ),
                        ),
                      ),
              child: const Text("Créer un compte"),
            ),
            const SizedBox(height: 16),
            const _OrSeparator(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _socialSignIn(
                        AuthService.instance.signInWithGoogle,
                      ),
              icon: const Text('🔵', style: TextStyle(fontSize: 18)),
              label: const Text('Continuer avec Google'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _socialSignIn(
                        AuthService.instance.signInWithApple,
                      ),
              icon: const Text('🍎', style: TextStyle(fontSize: 18)),
              label: const Text('Continuer avec Apple'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrSeparator extends StatelessWidget {
  const _OrSeparator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: KultivaColors.lightGreen.withOpacity(0.6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ou',
            style: TextStyle(color: KultivaColors.textSecondary),
          ),
        ),
        Expanded(
          child: Divider(
            color: KultivaColors.lightGreen.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
