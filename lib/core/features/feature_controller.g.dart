// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Central controller for handling feature actions triggered by UI buttons.
/// Manages camera lifecycle and prompt sending for each feature.

@ProviderFor(FeatureController)
const featureControllerProvider = FeatureControllerProvider._();

/// Central controller for handling feature actions triggered by UI buttons.
/// Manages camera lifecycle and prompt sending for each feature.
final class FeatureControllerProvider
    extends $NotifierProvider<FeatureController, void> {
  /// Central controller for handling feature actions triggered by UI buttons.
  /// Manages camera lifecycle and prompt sending for each feature.
  const FeatureControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureControllerHash();

  @$internal
  @override
  FeatureController create() => FeatureController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$featureControllerHash() => r'262a8e72744646f21c6fe86b4f7865e14d5b205a';

/// Central controller for handling feature actions triggered by UI buttons.
/// Manages camera lifecycle and prompt sending for each feature.

abstract class _$FeatureController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
