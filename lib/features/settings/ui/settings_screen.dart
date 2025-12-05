import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/ui/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ------------------------------------------
          // 🎨 MEGJELENÉS
          // ------------------------------------------
          const SectionHeader(title: 'Megjelenés'),
          
          // 1. Felület Módja (UiMode)
          _buildUiModeSetting(ref),

          // 2. Téma Mód (Dark Mode)
          _buildThemeModeSetting(ref),

          const Divider(height: 32),

          // ------------------------------------------
          // 🔊 HANG BEÁLLÍTÁSOK (TTS)
          // ------------------------------------------
          const SectionHeader(title: 'Hangbeállítások'),
          _buildTtsSettings(ref),

          const Divider(height: 32),

          // ------------------------------------------
          // ℹ️ INFORMÁCIÓ
          // ------------------------------------------
          const SectionHeader(title: 'Információ'),
          
          // Alkalmazás Verziója
          const SettingsTile(
            title: 'Alkalmazás Verziója',
            subtitle: '1.0.0 (Build 1)', // Ezt később olvashatod be a package_info_plus-szal
            trailing: null,
          ),
          
          // Egyéb linkek
          SettingsTile(
            title: 'Adatvédelmi Nyilatkozat',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Itt lehetne megnyitni egy URL-t
            },
          ),
          SettingsTile(
            title: 'Visszajelzés Küldése',
            trailing: const Icon(Icons.mail_outline),
            onTap: () {
              // TODO: Itt lehetne elindítani egy emailt
            },
          ),
        ],
      ),
    );
  }

  // --- Beállítási Widgetek ---

  // UI Mód beállítás
  Widget _buildUiModeSetting(WidgetRef ref) {
    final uiModeAsync = ref.watch(uiModeControllerProvider);
    
    return uiModeAsync.when(
      loading: () => const SettingsTile(title: 'Felület Módja', trailing: CircularProgressIndicator()),
      error: (e, s) => SettingsTile(title: 'Hiba a mód betöltésében', subtitle: e.toString()),
      data: (currentMode) {
        final controller = ref.read(uiModeControllerProvider.notifier);
        
        return SettingsTile(
          title: 'Felület Módja',
          subtitle: currentMode == UiMode.standard ? 'Standard nézet' : 'Egyszerűsített nézet',
          trailing: Switch(
            value: currentMode == UiMode.simplified,
            onChanged: (value) => controller.toggleMode(),
          ),
        );
      },
    );
  }

  // Téma Mód beállítás
  Widget _buildThemeModeSetting(WidgetRef ref) {
    final themeModeAsync = ref.watch(themeControllerProvider);
    
    return themeModeAsync.when(
      loading: () => const SettingsTile(title: 'Téma Mód', trailing: CircularProgressIndicator()),
      error: (e, s) => SettingsTile(title: 'Hiba a téma betöltésében', subtitle: e.toString()),
      data: (currentMode) {
        final controller = ref.read(themeControllerProvider.notifier);
        
        return SettingsTile(
          title: 'Sötét Téma',
          subtitle: 'Jelenlegi: ${currentMode.name.toUpperCase()}',
          // A legördülő menü (Dropdown) ideális a több válaszlehetőséghez
          trailing: DropdownButton<AppThemeMode>(
            value: currentMode,
            onChanged: (AppThemeMode? newMode) {
              if (newMode != null) {
                controller.setMode(newMode);
              }
            },
            items: AppThemeMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(mode.name.toUpperCase()),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// A szekciók fejlécének segéd-widgetje
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}