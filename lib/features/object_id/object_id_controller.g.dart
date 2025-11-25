// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_id_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ObjectIdController)
const objectIdControllerProvider = ObjectIdControllerProvider._();

final class ObjectIdControllerProvider
    extends $NotifierProvider<ObjectIdController, ObjectIdState> {
  const ObjectIdControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'objectIdControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$objectIdControllerHash();

  @$internal
  @override
  ObjectIdController create() => ObjectIdController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ObjectIdState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ObjectIdState>(value),
    );
  }
}

String _$objectIdControllerHash() =>
    r'82301e2fc401fd7b7a562141544a7c1f1ea5c5a9';

abstract class _$ObjectIdController extends $Notifier<ObjectIdState> {
  ObjectIdState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ObjectIdState, ObjectIdState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ObjectIdState, ObjectIdState>,
              ObjectIdState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
