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
    r'39ce46a69311baec78496729aa2b78669a2b6963';

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
