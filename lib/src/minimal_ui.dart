import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumiai/src/image_utils.dart';
import 'package:lumiai/src/tts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

    setState(() => _isLoading = true);
    ttsService.speak('Processing image. Please wait.');
    await Future.delayed(const Duration(milliseconds: 50));

    String resultMessage; // This will hold either the success or error message.

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(_fileForConfirmation!.path);
      final String safeFilePath = p.join(appDir.path, fileName);
      final File originalFileHandle = File(_fileForConfirmation!.path);

      final originalSize = (await originalFileHandle.length() / 1024).round();
      await originalFileHandle.copy(safeFilePath);

      final compressedBytes = await compressImageFromPath(safeFilePath);
      final compressedSize = (compressedBytes.lengthInBytes / 1024).round();

      // On success, create the success message.
      resultMessage =
          'Success!\nOriginal size: $originalSize KB\nNew size: $compressedSize KB';
      ttsService.speak('Processing complete.');

      try {
        await File(safeFilePath).delete();
      } catch (e) {
        print("Error deleting safe copy: $e");
      }
    } catch (e) {
      // On failure, create an error message.
      print('An error occurred during processing: $e');
      resultMessage = 'Processing Failed.\nPlease try again.';
      ttsService.speak('Sorry, an error occurred.');
    }

    // Finally, update the state to show the result screen with the message.
    setState(() {
      _processingResult = resultMessage;
      _isLoading = false;
    });
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

  /// Builds the result screen, showing success or failure.
  Widget _buildResultMenu(BuildContext context) {
    final bool isSuccess = _processingResult?.startsWith('Success') ?? false;

    final Color textColor = Colors.black;
    final Color iconColor = isSuccess
        ? Colors.green.shade400
        : Colors.red.shade400;
    final IconData icon = isSuccess
        ? Icons.check_circle_outline
        : Icons.error_outline;
    final Color buttonBackgroundColor = Theme.of(
      context,
    ).primaryColor.withAlpha(204);
    final Color buttonTextColor = Theme.of(
      context,
    ).primaryTextTheme.bodyLarge!.color!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, color: iconColor, size: 120),
        if (_processingResult != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _processingResult!,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: 24, height: 1.5),
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
          buttonTextColor: buttonTextColor,
          buttonIconColor: buttonTextColor,
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
            ? _buildResultMenu(context) // Use the new result menu
            : _fileForConfirmation != null
            ? _buildConfirmationMenu(context)
            : _buildMainMenu(context),
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
