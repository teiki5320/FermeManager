import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'providers/app_state.dart';
import 'screens/root_tabs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const FermeManagerApp());
}

class FermeManagerApp extends StatelessWidget {
  const FermeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: MaterialApp(
        title: 'FermeManager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        home: const RootTabs(),
      ),
    );
  }
}
