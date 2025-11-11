import 'package:flutter/material.dart';

/// Represents the UI for partially functional visually impaired users.
/// This UI offers more functionality and options while maintaining accessibility
/// principles, with slightly more detailed text and organized layouts.
class PartialFunctionalUI extends StatelessWidget {
  const PartialFunctionalUI({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme mode for consistency
    final Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardBackgroundColor = Theme.of(context).cardColor;
    final Color sectionTitleColor = Theme.of(context).textTheme.titleLarge!.color!; // Use titleLarge for section titles
    final Color buttonTextColor = Theme.of(context).primaryTextTheme.bodyLarge!.color!;
    final Color buttonIconColor = Theme.of(context).primaryIconTheme.color!;
    final Color buttonBackgroundColor = Theme.of(context).primaryColor.withAlpha(204); // Use theme primary color with opacity

    return Container(
      color: scaffoldBackgroundColor, // Use scaffold background color for consistency
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildSectionTitle(context, 'Object & Scene Recognition', sectionTitleColor),
          _buildCard(
            context,
            cardBackgroundColor,
            children: [
              _buildButtonRow(
                context,
                buttons: [
                  _buildFeatureButton(
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
                  _buildFeatureButton(
                    context,
                    label: 'Describe Scene',
                    icon: Icons.landscape,
                    onPressed: () {
                      // TODO: Implement scene description logic
                      _showVoicePrompt(context, 'Describe Scene selected. Analyzing your surroundings.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Text Assistance', sectionTitleColor),
          _buildCard(
            context,
            cardBackgroundColor,
            children: [
              _buildButtonRow(
                context,
                buttons: [
                  _buildFeatureButton(
                    context,
                    label: 'Read Document',
                    icon: Icons.description,
                    onPressed: () {
                      // TODO: Implement document reading logic
                      _showVoicePrompt(context, 'Read Document selected. Place document in front of the camera.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Scan Barcode',
                    icon: Icons.qr_code_scanner,
                    onPressed: () {
                      // TODO: Implement barcode scanning logic
                      _showVoicePrompt(context, 'Scan Barcode selected. Position barcode in the frame.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Navigation Aids', sectionTitleColor),
          _buildCard(
            context,
            cardBackgroundColor,
            children: [
              _buildButtonRow(
                context,
                buttons: [
                  _buildFeatureButton(
                    context,
                    label: 'Find My Way',
                    icon: Icons.navigation,
                    onPressed: () {
                      // TODO: Implement navigation assistance logic
                      _showVoicePrompt(context, 'Find My Way selected. Providing directional assistance.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                  _buildFeatureButton(
                    context,
                    label: 'Explore Surroundings',
                    icon: Icons.explore,
                    onPressed: () {
                      // TODO: Implement surroundings exploration logic
                      _showVoicePrompt(context, 'Explore Surroundings selected. Describing nearby points of interest.');
                    },
                    buttonBackgroundColor: buttonBackgroundColor,
                    buttonTextColor: buttonTextColor,
                    buttonIconColor: buttonIconColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings button, possibly more comprehensive
          _buildCard(
            context,
            cardBackgroundColor,
            children: [
              _buildFeatureButton(
                context,
                label: 'Settings',
                icon: Icons.settings,
                onPressed: () {
                  // TODO: Implement advanced settings logic
                  _showVoicePrompt(context, 'Settings selected. Accessing advanced customization options.');
                },
                isFullWidth: true, // Make settings button full width for prominence
                buttonBackgroundColor: buttonBackgroundColor,
                buttonTextColor: buttonTextColor,
                buttonIconColor: buttonIconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22, // Slightly smaller for modern feel
          fontWeight: FontWeight.w700, // Bolder weight
          color: textColor, // Use theme-provided text color
        ),
        textAlign: TextAlign.left, // Align left for a cleaner look
      ),
    );
  }

  Widget _buildCard(BuildContext context, Color cardBackgroundColor, {required List<Widget> children}) {
    return Card(
      elevation: 4.0, // Subtle shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: cardBackgroundColor, // Use theme-provided card color
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, {required List<Widget> buttons}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: button,
      ))).toList(),
    );
  }

  Widget _buildFeatureButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed, bool isFullWidth = false, required Color buttonBackgroundColor, required Color buttonTextColor, required Color buttonIconColor}) {
    return SizedBox(
      height: 100, // Slightly reduced height for a more compact modern look
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor, // Use theme-provided button background color
          foregroundColor: buttonTextColor, // Use theme-provided button text color
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjusted text size
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Slightly less rounded corners
          ),
          padding: const EdgeInsets.all(12),
        ),
        icon: Icon(icon, size: 36, color: buttonIconColor), // Slightly smaller icon with theme color
        label: Text(label, textAlign: TextAlign.center),
        onPressed: onPressed,
      ),
    );
  }

  void _showVoicePrompt(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice Prompt: "$message"'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueGrey[800], // Darker snackbar
      ),
    );
    // TODO: Integrate actual text-to-speech (e.g., flutter_tts package)
  }
}
