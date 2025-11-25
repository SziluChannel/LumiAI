// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_live_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod Provider
/// keepAlive: true is essential for WebSocket connections so they don't
/// close automatically when the UI rebuilds.

@ProviderFor(geminiLiveClient)
const geminiLiveClientProvider = GeminiLiveClientProvider._();

/// Riverpod Provider
/// keepAlive: true is essential for WebSocket connections so they don't
/// close automatically when the UI rebuilds.

final class GeminiLiveClientProvider
    extends
        $FunctionalProvider<
          GeminiLiveClient,
          GeminiLiveClient,
          GeminiLiveClient
        >
    with $Provider<GeminiLiveClient> {
  /// Riverpod Provider
  /// keepAlive: true is essential for WebSocket connections so they don't
  /// close automatically when the UI rebuilds.
  const GeminiLiveClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiLiveClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiLiveClientHash();

  @$internal
  @override
  $ProviderElement<GeminiLiveClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeminiLiveClient create(Ref ref) {
    return geminiLiveClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiLiveClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiLiveClient>(value),
    );
  }
}

String _$geminiLiveClientHash() => r'ef9ccd5fa22eb22a91bea6a88ec5c12c202856d9';
