// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geminiApiClient)
const geminiApiClientProvider = GeminiApiClientProvider._();

final class GeminiApiClientProvider
    extends
        $FunctionalProvider<GeminiApiClient, GeminiApiClient, GeminiApiClient>
    with $Provider<GeminiApiClient> {
  const GeminiApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiApiClientHash();

  @$internal
  @override
  $ProviderElement<GeminiApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GeminiApiClient create(Ref ref) {
    return geminiApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeminiApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeminiApiClient>(value),
    );
  }
}

String _$geminiApiClientHash() => r'7fedce135379c0de26f683f89b3c18a8c987445d';

@ProviderFor(geminiLiveMessages)
const geminiLiveMessagesProvider = GeminiLiveMessagesProvider._();

final class GeminiLiveMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<LiveServerMessage>,
          LiveServerMessage,
          Stream<LiveServerMessage>
        >
    with
        $FutureModifier<LiveServerMessage>,
        $StreamProvider<LiveServerMessage> {
  const GeminiLiveMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiLiveMessagesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiLiveMessagesHash();

  @$internal
  @override
  $StreamProviderElement<LiveServerMessage> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LiveServerMessage> create(Ref ref) {
    return geminiLiveMessages(ref);
  }
}

String _$geminiLiveMessagesHash() =>
    r'45649e1b757d0d882089ffbe34bfa6ddfdd9eb87';
