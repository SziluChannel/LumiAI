// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'haptic_feedback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HapticFeedbackController)
const hapticFeedbackControllerProvider = HapticFeedbackControllerProvider._();

final class HapticFeedbackControllerProvider
    extends $AsyncNotifierProvider<HapticFeedbackController, bool> {
  const HapticFeedbackControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticFeedbackControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticFeedbackControllerHash();

  @$internal
  @override
  HapticFeedbackController create() => HapticFeedbackController();
}

String _$hapticFeedbackControllerHash() =>
    r'3f3880e948a997b80b8e58c92f70b921ee2bd5c7';

abstract class _$HapticFeedbackController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
