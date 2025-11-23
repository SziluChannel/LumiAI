import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumiai/src/service/image_utils.dart';
import 'package:lumiai/src/service/tts_service.dart';
import 'package:http/http.dart' as http;

/// Represents the UI for minimally functional visually impaired users.
class MinimalFunctionalUI extends StatefulWidget {
  const MinimalFunctionalUI({super.key});

  @override
  State<MinimalFunctionalUI> createState() => _MinimalFunctionalUIState();
}

class _MinimalFunctionalUIState extends State<MinimalFunctionalUI> {
  bool _isLoading = false;
  // Store the XFile object itself, which contains the path.
  XFile? _fileForConfirmation;
  // This new state variable will hold the success message.
  // If it's not null, we show the success screen.
  String? _processingResult;

  /// Resets all state variables to return to the main menu.
  void _resetToMainMenu() {
    setState(() {
      _isLoading = false;
      _fileForConfirmation = null;
      _processingResult = null;
    });
  }

  /// Step 1: Captures an image and stores its file reference.
  Future<void> _captureImageForConfirmation() async {
    ttsService.speak('Opening camera.');
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        ttsService.speak('Camera closed. No image taken.');
        return;
      }

      setState(() => _fileForConfirmation = pickedFile);

      ttsService.speak(
        'Photo captured. Please confirm to proceed, or retake the photo.',
      );
    } catch (e) {
      print('An error occurred during image capture: $e');
      ttsService.speak('Sorry, an error occurred while opening the camera.');
    }
  }

  /// Step 2: Processes the confirmed image based on the platform.
  Future<void> _processAndAnalyzeImage() async {
    if (_fileForConfirmation == null) return;

    // Set loading state and give the UI a moment to rebuild and show the spinner.
    setState(() => _isLoading = true);
    ttsService.speak('Processing image. Please wait.');
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      late final Uint8List compressedBytes;
      final String path = _fileForConfirmation!.path;

      // --- PLATFORM-AWARE LOGIC ---
      if (kIsWeb) {
        // On Web, fetch the bytes from the blob URL and use the byte-based compressor.
        final response = await http.get(Uri.parse(path));
        compressedBytes = await compressImageBytes(response.bodyBytes);
      } else {
        // On Mobile/Desktop, use the efficient path-based compressor.
        compressedBytes = await compressImageFromPath(path);
      }
      // --- END OF PLATFORM-AWARE LOGIC ---

      final originalSize = (await _fileForConfirmation!.length() / 1024)
          .round();
      final compressedSize = (compressedBytes.lengthInBytes / 1024).round();
      final successMessage =
          'Processing complete.\nOriginal size: $originalSize KB\nNew size: $compressedSize KB';

      // Announce the result and update the state to show the success screen.
      ttsService.speak('Processing complete. Image is ready for analysis.');
      setState(() {
        _processingResult = successMessage;
        _isLoading = false; // Stop loading to show the success screen
      });

      // TODO: Send 'compressedBytes' to the Gemini API here.
    } catch (e) {
      print('An error occurred during processing: $e');
      ttsService.speak('Sorry, an error occurred while processing the image.');
      // On error, reset to the main menu.
      _resetToMainMenu();
    }
    // The 'finally' block is removed from here to prevent premature state reset.
  }

  /// Builds the main menu UI with the primary action buttons.
  Widget _buildMainMenu(BuildContext context) {
    final Color buttonTextColor = Theme.of(
      context,
    ).primaryTextTheme.bodyLarge!.color!;
    final Color buttonIconColor = Theme.of(context).primaryIconTheme.color!;
    final Color buttonBackgroundColor = Theme.of(
      context,
    ).primaryColor.withAlpha(204);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLargeButton(
          context,
          label: 'Identify Object',
          icon: Icons.camera_alt,
          onPressed: _captureImageForConfirmation, // Calls Step 1
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
    );
  }

  /// Builds the confirmation UI after a photo has been taken.
  Widget _buildConfirmationMenu(BuildContext context) {
    final Color confirmColor = Colors.green.shade700;
    final Color retakeColor = Colors.red.shade700;
    final Color textColor = Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Display the captured image for low-vision or sighted users.
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // --- START OF THE FIX ---
            // Conditionally choose the correct Image widget based on the platform.
            child: kIsWeb
                ? Image.network(
                    // Use Image.network for Web
                    _fileForConfirmation!.path,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    // Use Image.file for Mobile/Desktop
                    File(_fileForConfirmation!.path),
                    fit: BoxFit.contain,
                  ),
            // --- END OF THE FIX ---
          ),
        ),
        // Confirmation and Retake buttons
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLargeButton(
                context,
                label: 'Confirm',
                icon: Icons.check_circle,
                onPressed: _processAndAnalyzeImage, // Calls Step 2
                buttonBackgroundColor: confirmColor,
                buttonTextColor: textColor,
                buttonIconColor: textColor,
              ),
              _buildLargeButton(
                context,
                label: 'Retake',
                icon: Icons.cancel,
                onPressed: _captureImageForConfirmation, // Restarts Step 1
                buttonBackgroundColor: retakeColor,
                buttonTextColor: textColor,
                buttonIconColor: textColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the new success screen shown after processing is complete.
  Widget _buildSuccessMenu(BuildContext context) {
    final Color textColor = Theme.of(
      context,
    ).primaryTextTheme.bodyLarge!.color!;
    final Color iconColor = Colors.green.shade400;
    final Color buttonBackgroundColor = Theme.of(
      context,
    ).primaryColor.withAlpha(204);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Success Icon
        Icon(Icons.check_circle_outline, color: iconColor, size: 120),
        // Result Text
        if (_processingResult != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _processingResult!,
              textAlign: TextAlign.center,
              // Change the text color to black to ensure it's always visible.
              style: TextStyle(color: Colors.black, fontSize: 24, height: 1.5),
            ),
          ),
        _buildLargeButton(
          context,
          label: 'Main Menu',
          icon: Icons.home,
          onPressed: () {
            ttsService.speak('Returning to main menu.');
            _resetToMainMenu();
          },
          buttonBackgroundColor: buttonBackgroundColor,
          buttonTextColor: textColor,
          buttonIconColor: textColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBackgroundColor = Theme.of(
      context,
    ).scaffoldBackgroundColor;

    return Container(
      color: scaffoldBackgroundColor,
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.white,
              )
            : _processingResult != null
            ? _buildSuccessMenu(
                context,
              ) // If there's a result, show success screen.
            : _fileForConfirmation != null
            ? _buildConfirmationMenu(
                context,
              ) // Else, if there's a file, show confirmation.
            : _buildMainMenu(context), // Otherwise, show the main menu.
      ),
    );
  }

  // This helper function remains unchanged.
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
