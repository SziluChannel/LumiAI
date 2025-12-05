import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';
import 'package:lumiai/features/settings/ui/settings_tile.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/core/constants/app_themes.dart'; // Needed for CustomThemeType in dropdown
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // For AccessibilitySettingsScreen
import 'package:lumiai/core/services/feedback_service.dart'; // Import FeedbackService

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

          // 3. Accessibility Settings (Font Size)
          SettingsTile(
            title: 'Accessibility Settings',
            subtitle: 'Adjust font size for better readability',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              FeedbackService.triggerSuccessFeedback(); // Haptic feedback
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccessibilitySettingsScreen()),
              );
            },
          ),

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
    final themeStateAsync = ref.watch(themeControllerProvider); // Watch the full theme state

    return themeStateAsync.when(
      loading: () => Column( // Use Column for multiple loading indicators
        children: const [
          SettingsTile(title: 'Téma Mód', trailing: CircularProgressIndicator()),
          SettingsTile(title: 'Hozzáférhetőségi Téka', trailing: CircularProgressIndicator()),
        ],
      ),
      error: (e, s) => Column( // Use Column for multiple error messages
        children: [
          SettingsTile(title: 'Hiba a mód betöltésében', subtitle: e.toString()),
          SettingsTile(title: 'Hiba a custom téma betöltésében', subtitle: e.toString()),
        ],
      ),
      data: (themeState) {
        final controller = ref.read(themeControllerProvider.notifier);

        return Column(
          children: [
            // Standard Light/Dark/System Theme Selection
            SettingsTile(
              title: 'Téma Mód',
              subtitle: 'Jelenlegi: ${themeState.appThemeMode.name.toUpperCase()}',
              trailing: DropdownButton<AppThemeMode>(
                value: themeState.appThemeMode,
                onChanged: (AppThemeMode? newMode) {
                  if (newMode != null) {
                    controller.setAppThemeMode(newMode); // Use new method
                    // Reset custom theme if standard mode is selected
                    if (newMode != AppThemeMode.system) { // Only reset if not system
                       controller.setCustomThemeType(CustomThemeType.none);
                    }
                  }
                },
                items: AppThemeMode.values.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Text(mode.name.toUpperCase()),
                  );
                }).toList(),
              ),
            ),
            // Custom Accessibility Theme Selection
            SettingsTile(
              title: 'Hozzáférhetőségi Téka',
              subtitle: 'Jelenlegi: ${themeState.customThemeType.name.toUpperCase()}',
              trailing: DropdownButton<CustomThemeType>(
                value: themeState.customThemeType,
                onChanged: (CustomThemeType? newType) {
                  if (newType != null) {
                    controller.setCustomThemeType(newType);
                  }
                },
                items: CustomThemeType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                        type == CustomThemeType.none
                            ? 'None'
                            : type.name.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join(' '),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  // TTS beállítások
  Widget _buildTtsSettings(WidgetRef ref) {
    final ttsSettings = ref.watch(ttsSettingsControllerProvider);
    final controller = ref.read(ttsSettingsControllerProvider.notifier);
    final ttsServiceAsync = ref.watch(ttsServiceProvider); // Watch the AsyncValue

    return Column(
      children: [
        // Voice Selection
        ttsServiceAsync.when(
          data: (ttsService) {
            // Only show if voices are available
            if (ttsService.availableVoices.isEmpty) {
              return const SizedBox.shrink();
            }
            return SettingsTile(
              title: 'Hang (Voice)',
              subtitle: ttsService.availableVoices
                  .firstWhere(
                      (v) => v.identifier == ttsSettings.selectedVoice,
                      orElse: () => ttsService.availableVoices.first)
                  .name, // Display selected voice name
              trailing: DropdownButton<String>(
                value: ttsSettings.selectedVoice,
                onChanged: (String? newVoiceIdentifier) {
                  if (newVoiceIdentifier != null) {
                    controller.setSelectedVoice(newVoiceIdentifier);
                  }
                },
                items: ttsService.availableVoices.map((voice) {
                  return DropdownMenuItem(
                    value: voice.identifier,
                    child: Text(voice.name),
                  );
                }).toList(),
              ),
            );
          },
          loading: () =>
              const SettingsTile(title: 'Hang (Voice)', trailing: CircularProgressIndicator()),
          error: (e, s) =>
              SettingsTile(title: 'Hiba hang betöltésében', subtitle: e.toString()),
        ),
        
        // Pitch Slider
        SettingsTile(
          title: 'Hangmagasság (Pitch)',
          subtitle: ttsSettings.pitch.toStringAsFixed(1),
          trailing: SizedBox(
            width: 150, // Adjust width as needed
            child: Slider(
              value: ttsSettings.pitch,
              min: 0.5,
              max: 2.0,
              divisions: 15, // 0.1 increments
              onChanged: (value) => controller.setPitch(value),
            ),
          ),
        ),
        
        // Speed Slider
        SettingsTile(
          title: 'Beszédsebesség (Speed)',
          subtitle: ttsSettings.speed.toStringAsFixed(1),
          trailing: SizedBox(
            width: 150, // Adjust width as needed
            child: Slider(
              value: ttsSettings.speed,
              min: 0.1,
              max: 2.0,
              divisions: 19, // 0.1 increments
              onChanged: (value) => controller.setSpeed(value),
            ),
          ),
        ),
      ],
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
