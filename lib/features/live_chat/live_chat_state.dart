enum LiveChatStatus { idle, listening, processing, streaming, error }

class LiveChatState {
  final LiveChatStatus status;
  final String? messages; // The conversation text
  final String? errorMessage;

  const LiveChatState({
    this.status = LiveChatStatus.idle,
    this.messages,
    this.errorMessage,
  });

  LiveChatState copyWith({
    LiveChatStatus? status,
    String? messages,
    String? errorMessage,
  }) {
    return LiveChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
