// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_identifier_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ColorIdentifierController)
const colorIdentifierControllerProvider = ColorIdentifierControllerProvider._();

final class ColorIdentifierControllerProvider
    extends $NotifierProvider<ColorIdentifierController, ColorIdentifierState> {
  const ColorIdentifierControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorIdentifierControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorIdentifierControllerHash();

  @$internal
  @override
  ColorIdentifierController create() => ColorIdentifierController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorIdentifierState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorIdentifierState>(value),
    );
  }
}

String _$colorIdentifierControllerHash() =>
    r'c6b898daf4128891d205421ff1fd30a95af66c81';

abstract class _$ColorIdentifierController
    extends $Notifier<ColorIdentifierState> {
  ColorIdentifierState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ColorIdentifierState, ColorIdentifierState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ColorIdentifierState, ColorIdentifierState>,
              ColorIdentifierState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
