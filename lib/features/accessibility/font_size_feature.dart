import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// I. The Global State Management Model (FontSizeProvider)
class FontSizeProvider extends ChangeNotifier {
  double _scaleFactor = 1.0;
  static const double minScaleFactor = 1.0;
  static const double maxScaleFactor = 2.0;

  double get scaleFactor => _scaleFactor;

  void setScaleFactor(double newFactor) {
    if (newFactor >= minScaleFactor && newFactor <= maxScaleFactor) {
      _scaleFactor = newFactor;
      notifyListeners();
    }
  }
}

// II. The Settings UI (AccessibilitySettingsScreen)
class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Text(
                  'Text Size: ${(fontSizeProvider.scaleFactor * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Slider(
                  value: fontSizeProvider.scaleFactor,
                  min: FontSizeProvider.minScaleFactor,
                  max: FontSizeProvider.maxScaleFactor,
                  divisions: (FontSizeProvider.maxScaleFactor - FontSizeProvider.minScaleFactor) ~/ 0.1, // 10 steps for 0.1 increments
                  label: '${(fontSizeProvider.scaleFactor * 100).toStringAsFixed(0)}%',
                  onChanged: (newValue) {
                    fontSizeProvider.setScaleFactor(newValue);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // III. Implementation Example (ScaledTextWidget) demonstration
            const Text(
              'Example Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const ScaledTextWidget(
              text: 'This is an example text that will scale with the slider. '
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

// III. Implementation Example (ScaledTextWidget)
class ScaledTextWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        return Text(
          text,
          style: TextStyle(
            fontSize: baseFontSize * fontSizeProvider.scaleFactor,
            fontWeight: fontWeight,
            color: color,
          ),
        );
      },
    );
  }
}
