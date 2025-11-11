import 'package:flutter/material.dart';
import 'package:lumiai/src/tts_service.dart';

/// Represents the UI for minimally functional visually impaired users.
/// This UI focuses on extreme simplicity, large high-contrast buttons,
/// minimal text, and extensive voice prompts/feedback.
class MinimalFunctionalUI extends StatelessWidget {
  const MinimalFunctionalUI({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme mode for consistency
    final Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    // final Color sectionTitleColor = Theme.of(context).textTheme.titleLarge!.color!; // Removed unused variable
    final Color buttonTextColor = Theme.of(context).primaryTextTheme.bodyLarge!.color!;
    final Color buttonIconColor = Theme.of(context).primaryIconTheme.color!;
    // Use theme primary color with opacity for button background
    final Color buttonBackgroundColor = Theme.of(context).primaryColor.withAlpha(204);

    return Container(
      color: scaffoldBackgroundColor, // Use scaffold background color for consistency
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Large, high-contrast button for Object Identification
            _buildLargeButton(
              context,
              label: 'Identify Object',
              icon: Icons.camera_alt,
              onPressed: () {
                // TODO: Implement object identification logic
                _showVoicePrompt(context, 'Identify Object selected. Point your camera at an object.');
              },
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
                // TODO: Implement text reading logic
                _showVoicePrompt(context, 'Read Text selected. Place text in front of the camera.');
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
                // TODO: Implement basic settings logic
                _showVoicePrompt(context, 'Settings selected. Adjust voice speed or volume.');
              },
              buttonBackgroundColor: buttonBackgroundColor,
              buttonTextColor: buttonTextColor,
              buttonIconColor: buttonIconColor,
            ),
            _buildLargeButton(
              context,
              label: 'Test Voice',
              icon: Icons.volume_up,
              onPressed: () {
                // This now works directly, just as you wanted!
                ttsService.speak('This is a direct call to the global TTS service.');
              },
              buttonBackgroundColor: Colors.teal,
              buttonTextColor: buttonTextColor,
              buttonIconColor: buttonIconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed, required Color buttonBackgroundColor, required Color buttonTextColor, required Color buttonIconColor}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor, // Use theme-provided button background color
          foregroundColor: buttonTextColor, // Use theme-provided button text color
          textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
        ),
        icon: Icon(icon, size: 60, color: buttonIconColor), // Use theme-provided icon color
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  void _showVoicePrompt(BuildContext context, String message) {
    // In a real app, this would trigger a text-to-speech engine.
    // For now, we'll use a simple SnackBar as a visual placeholder.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice Prompt: "$message"'),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(204), // Use theme primary color for snackbar
      ),
    );
    // TODO: Integrate actual text-to-speech (e.g., flutter_tts package)
  }
}
