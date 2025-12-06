// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_policy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PrivacyPolicyController)
const privacyPolicyControllerProvider = PrivacyPolicyControllerProvider._();

final class PrivacyPolicyControllerProvider
    extends $AsyncNotifierProvider<PrivacyPolicyController, bool> {
  const PrivacyPolicyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyPolicyControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyPolicyControllerHash();

  @$internal
  @override
  PrivacyPolicyController create() => PrivacyPolicyController();
}

String _$privacyPolicyControllerHash() =>
    r'ddf58d9b006f7907bb590c36c13beb6fa50fb3eb';

abstract class _$PrivacyPolicyController extends $AsyncNotifier<bool> {
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
