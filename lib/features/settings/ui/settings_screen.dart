import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/ui/smtp_settings_dialog.dart';
import 'package:lumiai/features/settings/providers/theme_provider.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';
import 'package:lumiai/features/settings/providers/language_provider.dart';
import 'package:lumiai/features/settings/ui/settings_tile.dart';
import 'package:lumiai/core/services/tts_service.dart';
import 'package:lumiai/features/accessibility/font_size_feature.dart'; // For AccessibilitySettingsScreen
import 'package:lumiai/core/services/feedback_service.dart'; // Import FeedbackService
import 'package:lumiai/features/settings/providers/haptic_feedback_provider.dart';
import 'package:lumiai/features/settings/ui/privacy_policy_screen.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ------------------------------------------
          // 🎨 MEGJELENÉS
          // ------------------------------------------
          SectionHeader(title: l10n.appearance),

          // 0. Language Toggle
          _buildLanguageSetting(ref, l10n),

          // 1. Felület Módja (UiMode)
          _buildUiModeSetting(context, ref),

          // 2. Téma Mód (Dark Mode)
          _buildThemeModeSetting(context, ref),

          // 3. Accessibility Settings (Font Size)
          SettingsTile(
            title: l10n.accessibilitySettings,
            subtitle: l10n.accessibilitySettingsSubtitle,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref
                  .read(feedbackServiceProvider)
                  .triggerSuccessFeedback(); // Haptic feedback
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AccessibilitySettingsScreen(),
                ),
              );
            },
          ),

          const Divider(height: 32),

          // ------------------------------------------
          // 🔊 HANG BEÁLLÍTÁSOK (TTS)
          // ------------------------------------------
          SectionHeader(title: l10n.soundSettings),
          _buildTtsSettings(context, ref),

          const Divider(height: 32),

          // ------------------------------------------
          // 📳 HAPTIC FEEDBACK
          // ------------------------------------------
          SectionHeader(title: l10n.hapticFeedback),
          _buildHapticFeedbackSetting(context, ref),

          const Divider(height: 32),

          // ------------------------------------------
          // 📧 EMAIL SETTINGS
          // ------------------------------------------
          const SectionHeader(title: 'Email Settings'),
          SettingsTile(
            title: 'Configure Email Server',
            trailing: const Icon(Icons.email_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const SmtpSettingsDialog(),
              );
            },
          ),

          // ------------------------------------------
          // ℹ️ INFORMÁCIÓ
          // ------------------------------------------
          SectionHeader(title: l10n.information),

          // Alkalmazás Verziója
          SettingsTile(
            title: l10n.appVersion,
            subtitle:
                '1.0.0 (Build 1)', // Ezt később olvashatod be a package_info_plus-szal
            trailing: null,
          ),

          // Egyéb linkek
          SettingsTile(
            title: l10n.privacyPolicy,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          SettingsTile(
            title: l10n.sendFeedback,
            trailing: const Icon(Icons.mail_outline),
            onTap: () {
              ref.read(feedbackServiceProvider).triggerSuccessFeedback();
              _showFeedbackDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // --- Feedback Dialog ---
  void _showFeedbackDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    String selectedCategory = l10n.categoryGeneral;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(l10n.feedbackTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.nameOptional,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Email field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.emailOptional,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Category dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: l10n.categoryGeneral,
                      child: Text(l10n.categoryGeneral),
                    ),
                    DropdownMenuItem(
                      value: l10n.categoryBugReport,
                      child: Text(l10n.categoryBugReport),
                    ),
                    DropdownMenuItem(
                      value: l10n.categoryFeatureRequest,
                      child: Text(l10n.categoryFeatureRequest),
                    ),
                    DropdownMenuItem(
                      value: l10n.categoryUsability,
                      child: Text(l10n.categoryUsability),
                    ),
                    DropdownMenuItem(
                      value: l10n.categoryOther,
                      child: Text(l10n.categoryOther),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Message field
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '${l10n.message} *',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.message_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                // For now, just show a success message
                final message = messageController.text.trim();
                if (message.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.messageRequired),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Close the dialog
                Navigator.of(dialogContext).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.feedbackThanks),
                    backgroundColor: Colors.green,
                  ),
                );

                // Debug print the feedback (for now)
                debugPrint('📧 Feedback submitted:');
                debugPrint('  Name: ${nameController.text}');
                debugPrint('  Email: ${emailController.text}');
                debugPrint('  Category: $selectedCategory');
                debugPrint('  Message: $message');
              },
              child: Text(l10n.send),
            ),
          ],
        ),
      ),
    );
  }

  // --- Beállítási Widgetek ---

  // Language setting
  Widget _buildLanguageSetting(WidgetRef ref, AppLocalizations l10n) {
    final locale = ref.watch(languageControllerProvider);
    final controller = ref.read(languageControllerProvider.notifier);

    return SettingsTile(
      title: l10n.language,
      subtitle: locale.languageCode == 'hu' ? 'Magyar' : 'English',
      trailing: DropdownButton<String>(
        value: locale.languageCode,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'hu', child: Text('Magyar')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.setLocale(Locale(value));
          }
        },
      ),
    );
  }

  // UI Mód beállítás
  Widget _buildUiModeSetting(BuildContext context, WidgetRef ref) {
    final uiModeAsync = ref.watch(uiModeControllerProvider);

    return uiModeAsync.when(
      loading: () => SettingsTile(
        title: AppLocalizations.of(context).uiMode,
        trailing: const CircularProgressIndicator(),
      ),
      error: (e, s) => SettingsTile(
        title: AppLocalizations.of(context).errorLoadingMode,
        subtitle: e.toString(),
      ),
      data: (currentMode) {
        final controller = ref.read(uiModeControllerProvider.notifier);

        return SettingsTile(
          title: AppLocalizations.of(context).uiMode,
          subtitle: currentMode == UiMode.standard
              ? AppLocalizations.of(context).standardView
              : AppLocalizations.of(context).simplifiedView,
          trailing: Switch(
            value: currentMode == UiMode.simplified,
            onChanged: (value) => controller.toggleMode(),
          ),
        );
      },
    );
  }

  // Téma Mód beállítás
  Widget _buildThemeModeSetting(BuildContext context, WidgetRef ref) {
    final themeStateAsync = ref.watch(
      themeControllerProvider,
    ); // Watch the full theme state

    final l10n = AppLocalizations.of(context);

    return themeStateAsync.when(
      loading: () => Column(
        // Use Column for multiple loading indicators
        children: [
          SettingsTile(
            title: l10n.themeMode,
            trailing: const CircularProgressIndicator(),
          ),
          SettingsTile(
            title: l10n.accessibilityTheme,
            trailing: const CircularProgressIndicator(),
          ),
        ],
      ),
      error: (e, s) => Column(
        // Use Column for multiple error messages
        children: [
          SettingsTile(title: l10n.errorLoadingTheme, subtitle: e.toString()),
          SettingsTile(
            title: l10n.errorLoadingCustomTheme,
            subtitle: e.toString(),
          ),
        ],
      ),
      data: (themeState) {
        final controller = ref.read(themeControllerProvider.notifier);

        return Column(
          children: [
            // Standard Light/Dark/System Theme Selection
            SettingsTile(
              title: l10n.themeMode,
              subtitle: themeState.appThemeMode.name.toUpperCase(),
              trailing: DropdownButton<AppThemeMode>(
                value: themeState.appThemeMode,
                onChanged: (AppThemeMode? newMode) {
                  if (newMode != null) {
                    controller.setAppThemeMode(newMode); // Use new method
                    // Reset custom theme if standard mode is selected
                    if (newMode != AppThemeMode.system) {
                      // Only reset if not system
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
              title: l10n.accessibilityTheme,
              subtitle: themeState.customThemeType.name.toUpperCase(),
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
                          : type.name
                                .split('_')
                                .map((s) => s[0].toUpperCase() + s.substring(1))
                                .join(' '),
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

  // Haptic Feedback beállítás
  Widget _buildHapticFeedbackSetting(BuildContext context, WidgetRef ref) {
    final hapticFeedbackAsync = ref.watch(hapticFeedbackControllerProvider);

    final l10n = AppLocalizations.of(context);

    return hapticFeedbackAsync.when(
      loading: () => SettingsTile(
        title: l10n.hapticFeedback,
        trailing: const CircularProgressIndicator(),
      ),
      error: (e, s) =>
          SettingsTile(title: l10n.errorLoadingHaptic, subtitle: e.toString()),
      data: (isEnabled) {
        final controller = ref.read(hapticFeedbackControllerProvider.notifier);

        return SettingsTile(
          title: l10n.hapticFeedback,
          subtitle: isEnabled ? l10n.enabled : l10n.disabled,
          trailing: Switch(
            value: isEnabled,
            onChanged: (value) => controller.setHapticFeedback(value),
          ),
        );
      },
    );
  }

  // TTS beállítások
  Widget _buildTtsSettings(BuildContext context, WidgetRef ref) {
    final ttsSettings = ref.watch(ttsSettingsControllerProvider);
    final controller = ref.read(ttsSettingsControllerProvider.notifier);
    final ttsServiceAsync = ref.watch(
      ttsServiceProvider,
    ); // Watch the AsyncValue

    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Language Selection (TTS voice language, not UI language)
        SettingsTile(
          title: '${l10n.voice} ${l10n.language}',
          subtitle: ttsSettings.language == 'hu-HU'
              ? 'Magyar'
              : (ttsSettings.language == 'zh-CN' ? 'Chinese' : 'English'),
          trailing: DropdownButton<String>(
            value: ttsSettings.language,
            onChanged: (String? newLanguage) {
              if (newLanguage != null) {
                controller.setLanguage(newLanguage);
              }
            },
            items: const [
              DropdownMenuItem(value: 'en-US', child: Text('English')),
              DropdownMenuItem(value: 'hu-HU', child: Text('Magyar')),
              DropdownMenuItem(value: 'zh-CN', child: Text('Chinese')),
            ],
          ),
        ),

        // Voice Selection
        ttsServiceAsync.when(
          data: (ttsService) {
            // Only show if voices are available
            if (ttsService.availableVoices.isEmpty) {
              return const SizedBox.shrink();
            }
            return SettingsTile(
              title: l10n.voice,
              subtitle: ttsService.availableVoices
                  .firstWhere(
                    (v) => v.identifier == ttsSettings.selectedVoice,
                    orElse: () => ttsService.availableVoices.first,
                  )
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
          loading: () => SettingsTile(
            title: l10n.voice,
            trailing: const CircularProgressIndicator(),
          ),
          error: (e, s) => SettingsTile(
            title: l10n.errorLoadingVoice,
            subtitle: e.toString(),
          ),
        ),

        // Pitch Slider
        SettingsTile(
          title: l10n.pitch,
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
          title: l10n.speed,
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
