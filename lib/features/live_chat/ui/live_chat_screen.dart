import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../live_chat_controller.dart';
import '../live_chat_state.dart';

class LiveChatScreen extends ConsumerStatefulWidget {
  final Uint8List imageBytes;

  const LiveChatScreen({super.key, required this.imageBytes});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(liveChatControllerProvider.notifier)
          .startSession(widget.imageBytes);
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
            controller.stopRecordingAndSend();
          } else if (state.status == LiveChatStatus.idle) {
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
                    state.messages ?? "I am listening...",
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
