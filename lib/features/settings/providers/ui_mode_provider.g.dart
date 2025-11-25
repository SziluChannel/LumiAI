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
    extends $AsyncNotifierProvider<UiModeController, UiMode> {
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
}

String _$uiModeControllerHash() => r'dca0a02c28d386961021d04bbbfe493793900127';

abstract class _$UiModeController extends $AsyncNotifier<UiMode> {
  FutureOr<UiMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UiMode>, UiMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UiMode>, UiMode>,
              AsyncValue<UiMode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
