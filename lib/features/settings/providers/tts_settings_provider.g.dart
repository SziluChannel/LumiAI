// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TtsSettingsController)
const ttsSettingsControllerProvider = TtsSettingsControllerProvider._();

final class TtsSettingsControllerProvider
    extends $NotifierProvider<TtsSettingsController, TtsSettingsState> {
  const TtsSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ttsSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ttsSettingsControllerHash();

  @$internal
  @override
  TtsSettingsController create() => TtsSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TtsSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TtsSettingsState>(value),
    );
  }
}

String _$ttsSettingsControllerHash() =>
    r'7376487bf88618808c69eb208954c4379b323526';

abstract class _$TtsSettingsController extends $Notifier<TtsSettingsState> {
  TtsSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TtsSettingsState, TtsSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TtsSettingsState, TtsSettingsState>,
              TtsSettingsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
