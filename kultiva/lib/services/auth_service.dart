import 'dart:async';

import 'package:flutter/foundation.dart';

import 'prefs_service.dart';

/// Service d'authentification — version démo locale.
///
/// La v1 valide les emails localement et persiste la session via
/// [PrefsService]. Pour brancher Supabase en production :
///
///   1. Initialise `Supabase.initialize(url: …, anonKey: …)` dans `main.dart`
///      avant `runApp`.
///   2. Remplace le corps des méthodes ci-dessous par des appels à
///      `Supabase.instance.client.auth`.
///   3. Pour Google / Apple, branche `google_sign_in` et
///      `sign_in_with_apple`, puis signe avec `signInWithIdToken`.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  String? _email;
  String? _name;

  String? get email => _email;
  String? get name => _name;
  bool get isSignedIn => _email != null;

  Future<void> load() async {
    _email = PrefsService.instance.authEmail;
    _name = PrefsService.instance.authName;
    notifyListeners();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      throw const AuthException("Email invalide");
    }
    if (password.length < 6) {
      throw const AuthException(
          "Mot de passe trop court (6 caractères min.)");
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _email = email.trim();
    _name ??= _email!.split('@').first;
    await PrefsService.instance.setAuth(email: _email, name: _name);
    notifyListeners();
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    if (name.trim().isEmpty) {
      throw const AuthException("Le nom est requis");
    }
    await signInWithEmail(email: email, password: password);
    _name = name.trim();
    await PrefsService.instance.setAuth(email: _email, name: _name);
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // TODO: brancher google_sign_in + Supabase OAuth.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _email = 'demo.google@kultiva.app';
    _name = 'Jardinier Google';
    await PrefsService.instance.setAuth(email: _email, name: _name);
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    // TODO: brancher sign_in_with_apple + Supabase OAuth.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _email = 'demo.apple@kultiva.app';
    _name = 'Jardinier Apple';
    await PrefsService.instance.setAuth(email: _email, name: _name);
    notifyListeners();
  }

  Future<void> signOut() async {
    _email = null;
    _name = null;
    await PrefsService.instance.setAuth(email: null, name: null);
    notifyListeners();
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
