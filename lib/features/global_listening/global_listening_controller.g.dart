// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_listening_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalListeningController)
const globalListeningControllerProvider = GlobalListeningControllerProvider._();

final class GlobalListeningControllerProvider
    extends $NotifierProvider<GlobalListeningController, GlobalListeningState> {
  const GlobalListeningControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalListeningControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalListeningControllerHash();

  @$internal
  @override
  GlobalListeningController create() => GlobalListeningController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalListeningState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalListeningState>(value),
    );
  }
}

String _$globalListeningControllerHash() =>
    r'427cc1eabcbb8a0c020f325636a29a0fa2b4b8ae';

abstract class _$GlobalListeningController
    extends $Notifier<GlobalListeningState> {
  GlobalListeningState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GlobalListeningState, GlobalListeningState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GlobalListeningState, GlobalListeningState>,
              GlobalListeningState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
