// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light_meter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LightMeterController)
const lightMeterControllerProvider = LightMeterControllerProvider._();

final class LightMeterControllerProvider
    extends $NotifierProvider<LightMeterController, LightMeterState> {
  const LightMeterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightMeterControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightMeterControllerHash();

  @$internal
  @override
  LightMeterController create() => LightMeterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LightMeterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LightMeterState>(value),
    );
  }
}

String _$lightMeterControllerHash() =>
    r'ad2cf2830dc90f512406fa114477d842d6fc4c5e';

abstract class _$LightMeterController extends $Notifier<LightMeterState> {
  LightMeterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LightMeterState, LightMeterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LightMeterState, LightMeterState>,
              LightMeterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
