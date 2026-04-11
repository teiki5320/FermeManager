import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/root_tabs.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/prefs_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.instance.load();
  await AuthService.instance.load();
  runApp(const KultivaApp());
}

class KultivaApp extends StatelessWidget {
  const KultivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PrefsService.instance.darkMode,
      builder: (context, darkMode, _) {
        return MaterialApp(
          title: 'Kultiva',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          home: const _KultivaBootstrap(),
        );
      },
    );
  }
}

/// Orchestre le flow splash → onboarding → auth → main.
class _KultivaBootstrap extends StatefulWidget {
  const _KultivaBootstrap();

  @override
  State<_KultivaBootstrap> createState() => _KultivaBootstrapState();
}

enum _BootStep { splash, onboarding, auth, main }

class _KultivaBootstrapState extends State<_KultivaBootstrap> {
  _BootStep _step = _BootStep.splash;

  void _afterSplash() {
    setState(() {
      if (!PrefsService.instance.onboardingDone) {
        _step = _BootStep.onboarding;
      } else if (!AuthService.instance.isSignedIn) {
        _step = _BootStep.auth;
      } else {
        _step = _BootStep.main;
      }
    });
  }

  void _afterOnboarding() {
    setState(() {
      _step = AuthService.instance.isSignedIn
          ? _BootStep.main
          : _BootStep.auth;
    });
  }

  void _afterSignIn() => setState(() => _step = _BootStep.main);

  void _afterSignOut() => setState(() => _step = _BootStep.auth);

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case _BootStep.splash:
        return SplashScreen(onDone: _afterSplash);
      case _BootStep.onboarding:
        return OnboardingScreen(onDone: _afterOnboarding);
      case _BootStep.auth:
        return LoginScreen(onSignedIn: _afterSignIn);
      case _BootStep.main:
        return RootTabs(onSignOut: _afterSignOut);
    }
  }
}
