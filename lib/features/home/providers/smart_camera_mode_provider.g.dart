// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_camera_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmartCameraState)
const smartCameraStateProvider = SmartCameraStateProvider._();

final class SmartCameraStateProvider
    extends $NotifierProvider<SmartCameraState, SmartCameraMode> {
  const SmartCameraStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartCameraStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartCameraStateHash();

  @$internal
  @override
  SmartCameraState create() => SmartCameraState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmartCameraMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmartCameraMode>(value),
    );
  }
}

String _$smartCameraStateHash() => r'fc2c9218d985ed7725dbf166dafd3338ca39787c';

abstract class _$SmartCameraState extends $Notifier<SmartCameraMode> {
  SmartCameraMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SmartCameraMode, SmartCameraMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SmartCameraMode, SmartCameraMode>,
              SmartCameraMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
