// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LiveChatController)
const liveChatControllerProvider = LiveChatControllerProvider._();

final class LiveChatControllerProvider
    extends $NotifierProvider<LiveChatController, LiveChatState> {
  const LiveChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveChatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveChatControllerHash();

  @$internal
  @override
  LiveChatController create() => LiveChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveChatState>(value),
    );
  }
}

String _$liveChatControllerHash() =>
    r'e449c41807709b8827ed2d248028963caf2d5fb5';

abstract class _$LiveChatController extends $Notifier<LiveChatState> {
  LiveChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LiveChatState, LiveChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveChatState, LiveChatState>,
              LiveChatState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
