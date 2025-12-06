// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ttsService)
const ttsServiceProvider = TtsServiceProvider._();

final class TtsServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<TtsService>,
          TtsService,
          FutureOr<TtsService>
        >
    with $FutureModifier<TtsService>, $FutureProvider<TtsService> {
  const TtsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ttsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ttsServiceHash();

  @$internal
  @override
  $FutureProviderElement<TtsService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TtsService> create(Ref ref) {
    return ttsService(ref);
  }
}

String _$ttsServiceHash() => r'e89c0a1a0a281a025c74d71280a393a9336481fb';
