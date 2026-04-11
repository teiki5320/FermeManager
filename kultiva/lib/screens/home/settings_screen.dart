import 'package:flutter/material.dart';

import '../../models/region_data.dart';
import '../../services/auth_service.dart';
import '../../services/prefs_service.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onSignOut;
  const SettingsScreen({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          AppBar(title: const Text('Paramètres')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: <Widget>[
                _SectionTitle(title: '🌍  Région'),
                Card(
                  child: ValueListenableBuilder<Region>(
                    valueListenable: PrefsService.instance.region,
                    builder: (context, region, _) {
                      return Column(
                        children: <Widget>[
                          for (int i = 0; i < Region.values.length; i++) ...<Widget>[
                            if (i > 0)
                              const Divider(height: 0, indent: 16),
                            RadioListTile<Region>(
                              value: Region.values[i],
                              groupValue: region,
                              onChanged: (v) {
                                if (v != null) {
                                  PrefsService.instance.setRegion(v);
                                }
                              },
                              title: Text(
                                '${Region.values[i].emoji}   ${Region.values[i].label}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              activeColor: KultivaColors.primaryGreen,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: '🔔  Notifications'),
                Card(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: PrefsService.instance.notifications,
                    builder: (context, value, _) {
                      return SwitchListTile(
                        value: value,
                        onChanged:
                            PrefsService.instance.setNotifications,
                        activeColor: KultivaColors.primaryGreen,
                        title: const Text(
                          'Rappel mensuel',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text(
                          "Une notification le 1er de chaque mois",
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: '🌙  Apparence'),
                Card(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: PrefsService.instance.darkMode,
                    builder: (context, value, _) {
                      return SwitchListTile(
                        value: value,
                        onChanged: PrefsService.instance.setDarkMode,
                        activeColor: KultivaColors.primaryGreen,
                        title: const Text(
                          'Mode sombre',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _SectionTitle(title: '👤  Compte'),
                Card(
                  child: AnimatedBuilder(
                    animation: AuthService.instance,
                    builder: (context, _) {
                      final auth = AuthService.instance;
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  KultivaColors.lightGreen.withOpacity(0.4),
                              child: const Text('🌱'),
                            ),
                            title: Text(
                              auth.name ?? 'Invité',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(auth.email ?? 'Non connecté'),
                          ),
                          const Divider(height: 0, indent: 16),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: KultivaColors.terracotta,
                            ),
                            title: const Text(
                              'Se déconnecter',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onTap: () async {
                              await AuthService.instance.signOut();
                              onSignOut();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Kultiva v1.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: KultivaColors.textSecondary,
                        ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
