// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeController)
const themeControllerProvider = ThemeControllerProvider._();

final class ThemeControllerProvider
    extends $AsyncNotifierProvider<ThemeController, ThemeState> {
  const ThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeControllerHash();

  @$internal
  @override
  ThemeController create() => ThemeController();
}

String _$themeControllerHash() => r'7ebfc421107f727d98ac7dd8d1b65039ea072426';

abstract class _$ThemeController extends $AsyncNotifier<ThemeState> {
  FutureOr<ThemeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeState>, ThemeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeState>, ThemeState>,
              AsyncValue<ThemeState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentAppThemeMode)
const currentAppThemeModeProvider = CurrentAppThemeModeProvider._();

final class CurrentAppThemeModeProvider
    extends $FunctionalProvider<AppThemeMode, AppThemeMode, AppThemeMode>
    with $Provider<AppThemeMode> {
  const CurrentAppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAppThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAppThemeModeHash();

  @$internal
  @override
  $ProviderElement<AppThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppThemeMode create(Ref ref) {
    return currentAppThemeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeMode>(value),
    );
  }
}

String _$currentAppThemeModeHash() =>
    r'7edcb2299a0bc6e2f158170dd4f75744e6f4c154';

@ProviderFor(selectedAppTheme)
const selectedAppThemeProvider = SelectedAppThemeProvider._();

final class SelectedAppThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  const SelectedAppThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAppThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAppThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return selectedAppTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$selectedAppThemeHash() => r'12fdbe40fef296fc91bb0fc2fc562e0db29aa92f';
