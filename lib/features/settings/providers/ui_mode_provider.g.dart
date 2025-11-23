// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UiModeController)
const uiModeControllerProvider = UiModeControllerProvider._();

final class UiModeControllerProvider
    extends $NotifierProvider<UiModeController, UiMode> {
  const UiModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uiModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uiModeControllerHash();

  @$internal
  @override
  UiModeController create() => UiModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UiMode>(value),
    );
  }
}

String _$uiModeControllerHash() => r'3a9556568cbf12241215b1eb9d65bb2425c079d6';

abstract class _$UiModeController extends $Notifier<UiMode> {
  UiMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UiMode, UiMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UiMode, UiMode>,
              UiMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
