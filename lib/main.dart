import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'providers/modules_provider.dart';
import 'screens/root_tabs.dart';

void main() {
  runApp(const FermeManagerApp());
}

class FermeManagerApp extends StatelessWidget {
  const FermeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModulesProvider()..load(),
      child: MaterialApp(
        title: 'FermeManager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const RootTabs(),
      ),
    );
  }
}
