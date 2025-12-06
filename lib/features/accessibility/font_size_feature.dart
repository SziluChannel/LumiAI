import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// I. Font Size State
class FontSizeState {
  final double scaleFactor;

  const FontSizeState({this.scaleFactor = 1.0});

  static const double minScaleFactor = 1.0;
  static const double maxScaleFactor = 2.0;

  FontSizeState copyWith({double? scaleFactor}) {
    return FontSizeState(scaleFactor: scaleFactor ?? this.scaleFactor);
  }
}

// II. Font Size Notifier (Riverpod)
class FontSizeNotifier extends Notifier<FontSizeState> {
  @override
  FontSizeState build() {
    return const FontSizeState();
  }

  void setScaleFactor(double newFactor) {
    if (newFactor >= FontSizeState.minScaleFactor &&
        newFactor <= FontSizeState.maxScaleFactor) {
      state = state.copyWith(scaleFactor: newFactor);
    }
  }
}

// III. Provider
final fontSizeProvider = NotifierProvider<FontSizeNotifier, FontSizeState>(
  FontSizeNotifier.new,
);

// IV. The Settings UI (AccessibilitySettingsScreen)
class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeState = ref.watch(fontSizeProvider);
    final fontSizeNotifier = ref.read(fontSizeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Size: ${(fontSizeState.scaleFactor * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 18),
            ),
            Slider(
              value: fontSizeState.scaleFactor,
              min: FontSizeState.minScaleFactor,
              max: FontSizeState.maxScaleFactor,
              divisions:
                  (FontSizeState.maxScaleFactor -
                      FontSizeState.minScaleFactor) ~/
                  0.1, // 10 steps for 0.1 increments
              label: '${(fontSizeState.scaleFactor * 100).toStringAsFixed(0)}%',
              onChanged: (newValue) {
                fontSizeNotifier.setScaleFactor(newValue);
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // Implementation Example (ScaledTextWidget) demonstration
            const Text(
              'Example Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const ScaledTextWidget(
              text:
                  'This is an example text that will scale with the slider. '
                  'Observe how its size changes based on your selection.',
              baseFontSize: 16.0,
            ),
            const ScaledTextWidget(
              text: 'Smaller example text.',
              baseFontSize: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}

// V. Implementation Example (ScaledTextWidget)
class ScaledTextWidget extends ConsumerWidget {
  final String text;
  final double baseFontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const ScaledTextWidget({
    super.key,
    required this.text,
    required this.baseFontSize,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeState = ref.watch(fontSizeProvider);
    return Text(
      text,
      style: TextStyle(
        fontSize: baseFontSize * fontSizeState.scaleFactor,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
