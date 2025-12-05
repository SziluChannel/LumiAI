import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../live_chat_controller.dart';
import '../live_chat_state.dart';

class LiveChatScreen extends ConsumerStatefulWidget {
  final Uint8List? imageBytes; // Made nullable for easier navigation

  const LiveChatScreen({super.key, this.imageBytes});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start the continuous session when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(liveChatControllerProvider.notifier).startSession();
    });
  }

  @override
  void dispose() {
    // Stop the session when leaving the screen
    ref.read(liveChatControllerProvider.notifier).stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liveChatControllerProvider);
    final controller = ref.read(liveChatControllerProvider.notifier);

    final isListening = state.status == LiveChatStatus.listening;
    final isStreaming = state.status == LiveChatStatus.streaming;
    final isError = state.status == LiveChatStatus.error;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Live Analysis",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Status indicator
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isListening 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isListening ? Colors.green : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isListening ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isListening ? "LIVE" : "CONNECTING",
                      style: TextStyle(
                        color: isListening ? Colors.green : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. DYNAMIC VISUAL INDICATOR
          Expanded(
            flex: 1,
            child: Center(
              child: isError
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 80),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'An error occurred',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : StreamBuilder<double>(
                      stream: controller.amplitudeStream,
                      initialData: 0.0,
                      builder: (context, snapshot) {
                        final double volume = snapshot.data ?? 0.0;
                        // Scale between 1.0 (silent) and 2.5 (loud)
                        final double scale = 1.0 + (volume * 1.5);

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 100 * scale,
                          height: 100 * scale,
                          decoration: BoxDecoration(
                            color: isStreaming
                                ? Colors.blueAccent.withOpacity(0.5)
                                : Colors.green.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isStreaming ? Icons.record_voice_over : Icons.mic,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                    ),
            ),
          ),

          // 2. STATUS TEXT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              isError
                  ? "Error"
                  : isStreaming
                      ? "Speaking..."
                      : "Listening...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 3. CONVERSATION OUTPUT
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  (state.messages != null && state.messages!.isNotEmpty)
                      ? state.messages!
                      : "I am listening... speak naturally, and I'll respond.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
