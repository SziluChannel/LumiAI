import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/features/settings/providers/tts_settings_provider.dart';

void main() {
  test('TTS Settings persist across container rebuilds', () async {
    // 1. Initialize Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // 2. Create a container and change settings
    final container1 = ProviderContainer();

    // Initialize the provider
    container1.read(ttsSettingsControllerProvider);

    // Change the value
    await container1.read(ttsSettingsControllerProvider.notifier).setPitch(1.8);

    // Verify it updated in memory
    expect(container1.read(ttsSettingsControllerProvider).pitch, 1.8);

    // 3. Simulate "Restarting" the app by creating a NEW container
    final container2 = ProviderContainer();

    // Initialize the provider in the new container
    // This triggers build() -> _loadSettings()
    container2.read(ttsSettingsControllerProvider);

    // 4. WAIT for the async load to complete.
    // We poll the provider until the value changes from default (1.5) to expected (1.8)
    // or until we timeout.
    await expectLater(
      container2.read(ttsSettingsControllerProvider).pitch,
      1.5,
    ); // It starts at default

    // We need to give the event loop a chance to process the async SharedPreferences call
    await Future.delayed(const Duration(milliseconds: 100));

    // Now check if it updated
    expect(container2.read(ttsSettingsControllerProvider).pitch, 1.8);
  });
}
