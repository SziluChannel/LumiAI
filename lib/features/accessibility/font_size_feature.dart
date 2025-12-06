import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumiai/core/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final fontSizeState = ref.watch(fontSizeProvider);
    final fontSizeNotifier = ref.read(fontSizeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessibilitySettings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.textSize}: ${(fontSizeState.scaleFactor * 100).toStringAsFixed(0)}%',
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
            Text(
              '${l10n.exampleText}:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ScaledTextWidget(text: l10n.exampleTextContent, baseFontSize: 16.0),
            ScaledTextWidget(text: l10n.smallerExampleText, baseFontSize: 12.0),
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
