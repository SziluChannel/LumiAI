import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumiai/src/image_utils.dart';
import 'package:lumiai/src/tts_service.dart';

/// Represents the UI for minimally functional visually impaired users.
/// This UI focuses on extreme simplicity, large high-contrast buttons,
/// minimal text, and extensive voice prompts/feedback.
class MinimalFunctionalUI extends StatefulWidget {
  const MinimalFunctionalUI({super.key});

  @override
  State<MinimalFunctionalUI> createState() => _MinimalFunctionalUIState();
}

class _MinimalFunctionalUIState extends State<MinimalFunctionalUI> {
  bool _isLoading = false;

  /// This is the core logic for the "Identify Object" button.
  Future<void> _identifyObject() async {
    // 1. Provide voice feedback and enter loading state.
    ttsService.speak('Opening camera to identify object.');
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Open the camera.
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      // 3. Handle case where user cancels.
      if (pickedFile == null) {
        ttsService.speak('Camera closed. No image taken.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      ttsService.speak('Image captured. Now processing.');

      // 4. Read the image into memory.
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      // 5. Compress the image using the function from image_utils.dart.
      //    We pass `compute` to run it on a background thread on mobile.
      final Uint8List compressedBytes = await compressImageBytes(
        imageBytes,
        computeFn: kIsWeb ? null : (fn, args) => compute(fn, args),
      );

      // 6. The image is now ready for the Gemini API.
      //    For now, we'll just confirm with a voice prompt.
      final originalSize = (imageBytes.lengthInBytes / 1024).round();
      final compressedSize = (compressedBytes.lengthInBytes / 1024).round();
      final successMessage =
          'Processing complete. Image size reduced from $originalSize kilobytes to $compressedSize kilobytes. Ready for analysis.';
      print(successMessage); // For developer logging
      ttsService.speak(successMessage);

      // TODO: In the next step, send 'compressedBytes' to the Gemini API.
    } catch (e) {
      print('An error occurred: $e');
      ttsService.speak('Sorry, an error occurred during the process.');
    } finally {
      // 7. Exit loading state.
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme mode for consistency
    final Color scaffoldBackgroundColor = Theme.of(
      context,
    ).scaffoldBackgroundColor;
    final Color buttonTextColor = Theme.of(
      context,
    ).primaryTextTheme.bodyLarge!.color!;
    final Color buttonIconColor = Theme.of(context).primaryIconTheme.color!;
    // Use theme primary color with opacity for button background
    final Color buttonBackgroundColor = Theme.of(
      context,
    ).primaryColor.withAlpha(204);

    return Container(
      color:
          scaffoldBackgroundColor, // Use scaffold background color for consistency
      child: Center(
        // Show a loading indicator while processing, otherwise show buttons.
        child: _isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.white,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Large, high-contrast button for Object Identification
                  _buildLargeButton(
                    context,
                    label: 'Identify Object',
                    icon: Icons.camera_alt,
                    // The onPressed now calls our new logic function.
                    onPressed: _identifyObject,
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                  // Large, high-contrast button for Text Reading
                  _buildLargeButton(
                    context,
                    label: 'Read Text',
                    icon: Icons.text_fields,
                    onPressed: () {
                      ttsService.speak('Read Text selected.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                  // Large, high-contrast button for Settings
                  _buildLargeButton(
                    context,
                    label: 'Settings',
                    icon: Icons.settings,
                    onPressed: () {
                      ttsService.speak('Settings selected.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLargeButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color buttonBackgroundColor,
    required Color buttonTextColor,
    required Color buttonIconColor,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              buttonBackgroundColor, // Use theme-provided button background color
          foregroundColor:
              buttonTextColor, // Use theme-provided button text color
          textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
        ),
        icon: Icon(
          icon,
          size: 60,
          color: buttonIconColor,
        ), // Use theme-provided icon color
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
