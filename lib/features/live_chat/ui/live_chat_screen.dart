import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../live_chat_controller.dart';
import '../live_chat_state.dart';

class LiveChatScreen extends ConsumerStatefulWidget {
  final Uint8List imageBytes; // Kept in case you re-enable image context later

  const LiveChatScreen({super.key, required this.imageBytes});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start the session when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // NOTE: The manual LiveChatController currently assumes text/audio only.
      // If you add image support back to the manual client, pass widget.imageBytes here.
      ref.read(liveChatControllerProvider.notifier).startSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liveChatControllerProvider);
    final controller = ref.read(liveChatControllerProvider.notifier);

    final isListening = state.status == LiveChatStatus.listening;
    final isProcessing = state.status == LiveChatStatus.processing;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Live Analysis",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: InkWell(
        // Massive touch area for accessibility
        onTap: () {
          if (isListening) {
            // NEW: Method name changed to match streaming logic
            controller.stopRecording();
          } else if (state.status == LiveChatStatus.idle ||
              state.status == LiveChatStatus.streaming) {
            // Allow restarting even if currently speaking/streaming
            controller.startRecording();
          }
        },
        child: Column(
          children: [
            // 1. DYNAMIC VISUAL INDICATOR
            Expanded(
              flex: 1,
              child: Center(
                child: isListening
                    ? StreamBuilder<double>(
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
                              color: Colors.redAccent.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 50,
                            ),
                          );
                        },
                      )
                    : isProcessing
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 6,
                      )
                    : const Icon(Icons.touch_app, color: Colors.blue, size: 80),
              ),
            ),

            // 2. STATUS TEXT
            Text(
              isListening
                  ? "Tap to Stop"
                  : (isProcessing ? "Thinking..." : "Tap to Ask Again"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

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
                    // Default text prompt if messages are empty
                    (state.messages != null && state.messages!.isNotEmpty)
                        ? state.messages!
                        : "I am listening...",
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
      ),
    );
  }
}
