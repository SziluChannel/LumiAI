import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/ui_mode_provider.dart';

// Imports for your specific features and settings
import 'layouts/minimal_ui.dart';
import 'layouts/partial_ui.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Listen to the global UI Mode state
    final uiMode = ref.watch(uiModeControllerProvider);

    // 2. Determine the Title and Background Color based on mode
    final isSimplified = uiMode == UiMode.simplified;
    final String title = isSimplified ? "LumiAI (Simple)" : "LumiAI";
    final Color? appBarColor = isSimplified
        ? Colors.blueGrey[900]
        : null; // High contrast for simple

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: appBarColor,
        foregroundColor: isSimplified ? Colors.white : null,
        actions: [
          // --- TEMPORARY TOGGLE BUTTON ---
          // This allows you to switch modes easily for testing.
          // Later, you can move this logic into your 'Settings' button.
          IconButton(
            icon: Icon(
              isSimplified ? Icons.toggle_on : Icons.toggle_off,
              size: 30,
            ),
            tooltip: 'Switch UI Mode',
            onPressed: () {
              ref.read(uiModeControllerProvider.notifier).toggleMode();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // 3. The Body Switcher
      // This is where the magic happens. We swap the entire widget tree
      // based on the selected mode.
      body: switch (uiMode) {
        UiMode.simplified => const MinimalFunctionalUI(),
        UiMode.standard => const PartialFunctionalUI(),
      },
    );
  }
}
