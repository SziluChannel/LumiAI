// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_live_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GeminiLiveClient)
const geminiLiveClientProvider = GeminiLiveClientProvider._();

final class GeminiLiveClientProvider
    extends $NotifierProvider<GeminiLiveClient, GeminiLiveClient> {
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
  GeminiLiveClient create() => GeminiLiveClient();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiLiveClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiLiveClient>(value),
    );
  }
}

String _$geminiLiveClientHash() => r'53881d7113134a74838986baf34912fa336fe5a1';

abstract class _$GeminiLiveClient extends $Notifier<GeminiLiveClient> {
  GeminiLiveClient build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GeminiLiveClient, GeminiLiveClient>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GeminiLiveClient, GeminiLiveClient>,
              GeminiLiveClient,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
